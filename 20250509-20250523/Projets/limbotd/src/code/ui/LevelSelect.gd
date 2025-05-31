extends Control


signal closed


onready var grid := $GridContainer
var items : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	items = grid.get_children()
	for i in range(grid.get_child_count()):
		var left = null
		var right = null
		if i > 0:
			left = items[i - 1]
		if i < len(items) - 1:
			right = items[i + 1]
		
		items[i].set_focus(left, right)
	
	hide()






# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func appear()->void:
	visible = true
	items[0].grab_focus()


func disappear()->void:
	visible = false



func _unhandled_input(_event):
	if not visible:
		return
	if Input.is_action_just_pressed("ui_cancel"):
		emit_signal("closed")
