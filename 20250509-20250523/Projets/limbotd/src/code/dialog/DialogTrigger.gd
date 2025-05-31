extends Node2D
class_name DialogTrigger


export(String) var timeline : String = ""
export var wait_time : float = 2.0

var timer : Timer = Timer.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = PAUSE_MODE_PROCESS
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = wait_time
	var __ = timer.connect("timeout", self, "_on_timer_timeout")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func launch()->void:
	if wait_time > 0.000001:
		timer.start()
	else:
		start()



func start()->void:
	if not Dialogic.timeline_exists(timeline):
		push_error(timeline + " does not exists")
		return
	var dialog = Dialogic.start(timeline)
	add_child(dialog)
	dialog.connect("timeline_end", self, "_on_dialog_timeline_end")
	get_tree().paused = true



func _on_dialog_timeline_end(_t)->void:
	get_tree().paused = false


func _on_timer_timeout()->void:
	start()
