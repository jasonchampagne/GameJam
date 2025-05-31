extends Area2D


signal tower_requested(spot)
signal menu_requested(spot)


onready var build_effect := $BuildEffect


var tower




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func spawn_tower(tower_scene_path, blueprint : TowerBlueprint)->void:
	if tower != null:
		return
	var scene : PackedScene = load(tower_scene_path)
	tower = scene.instance()
	tower.set_blueprint(blueprint)
	add_child(tower)
	build_effect.emitting = true




func sell_tower()->void:
	tower.queue_free()
	PLAYER.money += tower.get_sell_value()
	tower = null


func upgrade_tower()->void:
	print("tower upgraded !")


func request_tower()->void:
	emit_signal("tower_requested", self)



func on_tower_clicked()->void:
	request_menu()
	tower.set_is_show_range(true)


func request_menu()->void:
	emit_signal("menu_requested", self)


func appear()->void:
	visible = true


func _on_TowerSpot_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			if tower == null:
				request_tower()
			else:
				on_tower_clicked()
