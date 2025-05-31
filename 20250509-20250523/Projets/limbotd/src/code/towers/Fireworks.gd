extends "res://code/towers/Tower.gd"


func _ready():
	._ready()
	randomize()

func get_target()->void:
	var available := get_available_targets()
	if len(available) == 0:
		target = null
		return
	
	available.shuffle()
	target = available[0]


func set_shoot():
	.set_shoot()
	get_target()
