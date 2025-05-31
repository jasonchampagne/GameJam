extends Area2D


export var damages : float = 0


onready var homing_component := $HomingComponent


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func reached(_target)->void:
	for bodies in get_overlapping_bodies():
		bodies.damage(damages)
	queue_free()
	


func on_target_is_no_more():
	reached(null)
