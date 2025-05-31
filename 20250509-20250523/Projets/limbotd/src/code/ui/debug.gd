extends Control


onready var grid := $GridContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	grid.get_child(0).grab_focus()
	var items = grid.get_children()
	for i in range(grid.get_child_count()):
		var left = null
		var right = null
		if i > 0:
			left = items[i - 1]
		if i < len(items) - 1:
			right = items[i + 1]
		
		items[i].set_focus(left, right)
	
	items[0].grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
