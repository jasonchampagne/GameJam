extends Node2D


signal all_spawned


export(PoolRealArray) var time_before_start_wave : PoolRealArray = [0.05]
export(Dictionary) var start_timelines : Dictionary = {}

onready var next_wave_timer := $NextWaveTimer
onready var initial_timer := $InitialTimer


var current_wave : int = 0 + DEBUG.wavemanager_wave_offset

# needed because current_wave is incremented when the timer for the next wave starts.
var waves_ended : int = 0

var all_waves : Array

var is_all_waves_launched : bool = false

var disabled : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	var __ = PLAYER.connect("dead", self, "_on_player_dead")
	for node in get_children():
		if not node is Timer:
			all_waves.append(node)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func start()->void:
	print("begin waves spawn")
	initial_timer.start()



func set_next_wave_timer_wait_time()->void:
	next_wave_timer.wait_time = clamp(time_before_start_wave[current_wave], 0.05, 120)


func setup_current_wave(ignore_wait : bool = false)->void:
	if disabled:
		return
	if ignore_wait:
		launch_wave()
		return
	set_next_wave_timer_wait_time()
	next_wave_timer.start()


func launch_children()->void:
	if disabled:
		return
	for node in all_waves[current_wave].get_children():
		if node is DialogTrigger:
			node.launch()
		elif node.has_method("start"):
			var __ = node.connect("spawned_all", self, "_on_spawner_spawned_all")
			node.start()


func start_current_wave()->void:
	print("Starting the timer before wave ", current_wave, " : ",
		time_before_start_wave[current_wave], "s")
	setup_current_wave()


#current_wave stores the wave currently waiting to be launched (the timer before it runs)
func start_wait_next_wave()->void:
	current_wave += 1
	start_current_wave()



func is_all_enemies_spawned()->bool:
	if current_wave < len(all_waves) - 1:
		return false
	for node in all_waves[current_wave].get_children():
		if node.has_method("start") and not node is DialogTrigger:
			if not node.is_finished:
				return false
	
	return true


func launch_wave()->void:
	if disabled:
		return
	if current_wave in start_timelines:
		var dialog = Dialogic.start(start_timelines[current_wave])
		add_child(dialog)
		dialog.pause_mode = PAUSE_MODE_PROCESS
		get_tree().paused = true
		yield(dialog, "timeline_end")
		get_tree().paused = false
	
	launch_children()
	print("wave ", current_wave, " is now launched")
	if current_wave + 1 >= len(all_waves):
		print("all waves have been launched")
		is_all_waves_launched = true
		return
		
	start_wait_next_wave()


func _on_NextWaveTimer_timeout():
	if current_wave != 0: # if the first wave is not launched the player has survived 0 waves
		waves_ended += 1
	print(waves_ended, " waves ended")
	launch_wave()



func _on_InitialTimer_timeout():
	print("Starting the first wave")
	setup_current_wave(
		DEBUG.wavemanager_ignore_initial_time
	)


func _on_spawner_spawned_all()->void:
	if not is_all_waves_launched:
		return
	
	if is_all_enemies_spawned():
		print("all enemies have been spawned")
		emit_signal("all_spawned")


func _on_player_dead()->void:
	disabled = true
	next_wave_timer.stop()
