extends Line2D
class_name LaserComponent


export(NodePath) var muzzle_path : String = ""
export(NodePath) var impact_effect : String = ""
export(NodePath) var impact_light_path : String = ""

onready var muzzle := get_node_or_null(muzzle_path)
onready var effect : Particles2D = get_node_or_null(impact_effect)
onready var impact_light := get_node_or_null(impact_light_path)




func _ready():
	if muzzle == null:
		muzzle = owner


func _process(_delta):
	if owner.target == null or not is_instance_valid(owner.target):
		if points.size() != 0:
			points = []
			if effect != null:
				effect.emitting = false
				if impact_light != null:
					impact_light.emitting = false
		return
	
	var dir : Vector2 = owner.target.global_position.direction_to(muzzle.global_position)
	var enemy_radius : float = owner.target.shape_owner_get_shape(
		owner.target.shape_find_owner(0), 0
	).radius
	var impact_point : Vector2 = owner.target.global_position + dir * enemy_radius
	if effect != null:
		effect.global_position = impact_point
		effect.look_at(muzzle.global_position)
		
		
		if not effect.emitting:
			effect.emitting = true
			if impact_light != null:
				impact_light.emitting = true
	points = [muzzle.position, owner.to_local(impact_point)]
	
