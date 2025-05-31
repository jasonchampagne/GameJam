extends "res://code/enemies/EnemySpawner.gd"


var all_positions : Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()
	if get_child_count() < 1:
		push_error(name + " has no position. No enemy will be spawned")
	for node in get_children():
		if not node is Timer:
			all_positions.append(node)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func spawn_one()->void:
	for pos in all_positions:
		var enemy = scene.instance()
		
		
		
		path.add_child(enemy)
		enemy.global_position = path.curve.get_point_position(0) + pos.position
		
		if enemy.has_node("PathFollowComponent"):
			var path_follow : PathFollowComponent = enemy.get_node("PathFollowComponent")
			path_follow.offset = pos.position
			path_follow.target_point = path.curve.get_point_position(0) + pos.position
		
		spawned += 1
