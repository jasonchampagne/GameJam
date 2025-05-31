extends Node
class_name LifeComponent

signal hit()
signal dead(node)


export var max_life : float = 100


onready var life : float = max_life


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_life(value : float)->void:
	life = clamp(value, 0.0, max_life)


func damage(amount : float)->void:
	set_life(life - amount)
	emit_signal("hit")
	if life == 0.0:
		emit_signal("dead", owner)
		owner.kill()
