extends Node
class_name ShootComponent

export var shooting_rate : float = 0.2


var shoot_timer : Timer

var is_shooting : bool = false setget set_shoot


# Called when the node enters the scene tree for the first time.
func _ready():
	if shooting_rate <= 0:
		return
	shoot_timer = Timer.new()
	shoot_timer.wait_time = shooting_rate
	add_child(shoot_timer)
	
	var __ = shoot_timer.connect("timeout", self, "_on_ShootTimer_timeout")



func set_time(new_wait_time : float)->void:
	shoot_timer.wait_time = new_wait_time
	shoot_timer.start()



func set_shoot(shooting)->void:
	var previous : bool = is_shooting
	is_shooting = shooting
	if is_shooting and is_shooting != previous:
		owner.shoot()
		if shooting_rate > 0:
			shoot_timer.start()
	elif shooting_rate > 0:
		shoot_timer.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if shooting_rate <= 0:
		owner.shoot()



func _on_ShootTimer_timeout():
	owner.shoot()
