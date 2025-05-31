extends StaticBody2D



export var tower_range : int = 250
export var damages : float = 10
export var slow : float = 0.0
export(PackedScene) var bullet_scene : PackedScene

export(NodePath) var muzzle_path : String = ""
export var lock_rotation : bool = false


onready var muzzle := get_node_or_null(muzzle_path)
onready var tower_common := $TowerCommon



onready var detect_area := $Detection
onready var shoot_component := $ShootComponent


var blueprint : TowerBlueprint
var level : int = 0
var max_level : int = 0

var target

var total_money_value : int = 0

var debug_colors : bool = DEBUG.tower_status

var rent_waves_count : int = -1


# Called when the node enters the scene tree for the first time.
func _ready():
	set_range(tower_range)
	if muzzle == null:
		muzzle = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	handle_shooting()


func _draw():
	if DEBUG.tower_show_range:
		var owner_id : int = detect_area.shape_find_owner(0)
		var shape = detect_area.shape_owner_get_shape(owner_id, 0)
		draw_arc(Vector2.ZERO, shape.radius, 0.0, 2 * PI, 100, Color.yellow)


func set_blueprint(bp : TowerBlueprint)->void:
	blueprint = bp
	max_level = len(blueprint.upgrades)
	total_money_value = blueprint.cost


func get_sell_value()->int:
	return int(floor(total_money_value * blueprint.sell_value_scale))


func set_range(value : int)->void:
	tower_range = value
	var shape = detect_area.shape_owner_get_shape(
		detect_area.shape_find_owner(0), 0
	)
	shape.radius = value
	update()
	tower_common.set_range()


func set_is_show_range(showing : bool)->void:
	tower_common.show_range(showing)


func handle_shooting()->void:
	if not is_instance_valid(target) or not is_target_in_range():
		get_target()
	if target == null or not is_instance_valid(target) or not is_target_in_range():
		target = null
		if debug_colors:
			modulate = Color.blueviolet
		shoot_component.is_shooting = false
		
		return
	aim()
	set_shoot()


func aim()->void:
	if lock_rotation:
		return
	look_at(target.global_position)


func set_shoot()->void:
	if target == null:
		return
	
	if not shoot_component.is_shooting:
		shoot_component.is_shooting = true
		if debug_colors:
			modulate = Color.white


func can_upgrade()->bool:
	return level < max_level


func is_using_bullet()->bool:
	return bullet_scene != null


func is_target_in_range()->bool:
	return target in detect_area.get_overlapping_bodies()


func get_available_targets()->Array:
	return detect_area.get_overlapping_bodies()


func get_target()->void:
	var bodies : Array = get_available_targets()
	if len(bodies) == 0:
		return
	bodies.sort_custom(self, "enemy_comp")
	if bodies.empty():
		target = null
		return
	
	target = bodies[0]


func enemy_comp(body1, body2)->bool:
	return global_position.distance_to(body1.global_position) < (
		global_position.distance_to(body2.global_position)
	)


func shoot()->void:
	if not is_instance_valid(target):
		shoot_component.is_shooting = false
		return
	shoot_impl()


func shoot_impl()->void:
	if not is_using_bullet():
		target.damage(damages)
		if target.has_method("set_slow"):
			target.set_slow(slow)
		return
	
	var bullet = bullet_scene.instance()
	bullet.damages = damages
	get_parent().get_parent().add_child(bullet)
	bullet.global_position = muzzle.global_position
	
	bullet.homing_component.target = target


func upgrade(up : TowerUpgrade)->void:
	if not can_upgrade():
		return
	
	level = int(clamp(level + 1, 0, max_level))

	damages = up.new_damage
	total_money_value += up.cost
	
	if up.new_range != null:
		set_range(up.new_range)
	
	if up.fire_rate != -1:
		shoot_component.set_time(up.fire_rate)
	
	
	tower_common.on_upgrade()


#
#func _on_Detection_body_entered(body):
#	if target == null:
#		target = body
