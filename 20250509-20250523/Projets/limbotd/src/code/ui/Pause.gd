extends Control


var paused : bool = false

var disabled : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_paused(value : bool)->void:
	if disabled:
		return

	paused = value
	if paused:
		get_tree().paused = true
		show()
	else:
		get_tree().paused = false
		hide()


func _unhandled_input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("pause"):
			set_paused(not paused)

