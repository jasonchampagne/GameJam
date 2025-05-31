extends KinematicBody2D


signal slowed(amount)


onready var life := $LifeComponent
onready var shaders := $Shader
onready var collision_shape := $CollisionShape2D

onready var lifebar := $Lifebar
onready var lifebar_initial_position : Vector2 = lifebar.rect_position

var slow_amount : float = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	lifebar.set_as_toplevel(true)
	update_lifebar()
	lifebar.rect_global_position = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	lifebar.rect_global_position = global_position + lifebar_initial_position



func damage(amount)->void:
	life.damage(amount)



func kill()->void:
	queue_free()



func set_slow(value : float)->void:
	emit_signal("slowed", value)


func update_lifebar()->void:
	lifebar.value = life.life / life.max_life * 100


func on_end_of_path()->void:
	PLAYER.life -= 1
	queue_free()


func _on_LifeComponent_hit():
#	shaders.blink()
	update_lifebar()
