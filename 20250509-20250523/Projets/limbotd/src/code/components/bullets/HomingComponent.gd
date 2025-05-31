extends Node
class_name HomingComponent


export var speed : float = 200


var target

#to prevent bullet never reach enemy due to enemy speed
var speed_scale : float = 0.0

var is_reached : bool = false


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_instance_valid(target):
		#bullet effects can be triggered if the target is already died (i.e explosions)
		if owner.has_method("on_target_is_no_more"):
			owner.on_target_is_no_more()
		owner.queue_free()
		return
	if is_reached:
		return
	move(delta)
	owner.look_at(target.global_position)


func move(delta)->void:
	var dir : Vector2 = target.global_position - owner.global_position
	
	var dist_moved : float = speed * delta * exp(speed_scale)
	owner.global_position += dist_moved * dir.normalized()
	
	speed_scale += 0.01
	
	if dir.length() < dist_moved:
		if target.has_method("damage"):
			is_reached = true
			owner.reached(target)
