extends Node2D


export var player_money : int = 300

export var end_timeline : String = ""

export var custom_death : String = ""



onready var shop := $ui/Shop
onready var tower_menu := $ui/TowerMenu
onready var game_over := $ui/GameOver
onready var pause_menu := $ui/Pause

onready var fade_rect := $ui/Fade

onready var wave_manager := $WaveManager

onready var tower_spots := $Spots
onready var all_paths := $AllPaths

onready var win_check_timer := $WinCheck


# Called when the node enters the scene tree for the first time.
func _ready():
	print(name, "\n")
	var __ = PLAYER.connect("dead", self, "_on_player_dead")
	
	PLAYER.set_stats(player_money)
	for spot in tower_spots.get_children():
		connect_spot(spot)
	
	fade_rect.show()
	fade_rect.modulate = Color.black
	
	var tween = get_tree().create_tween()
	__ = tween.tween_property(fade_rect, "modulate", Color(0, 0, 0, 0), 0.5)
	tween.play()
	
	yield(tween, "finished")
	fade_rect.hide()
	
	wave_manager.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func connect_spot(spot)->void:
	var __ = spot.connect("tower_requested", shop, "_on_tower_spot_tower_requested")
	__ = spot.connect("menu_requested", tower_menu, "_on_tower_spot_menu_requested")


func check_if_no_enemy()->bool:
	for path in all_paths.get_children():
		if path.get_child_count() != 0:
			return false
	
	return true


func on_level_win()->void:
	print("level end")
	
	if end_timeline != "":
		var dialog = Dialogic.start(end_timeline)
		add_child(dialog)
		
		yield(dialog, "timeline_end")
	var __ = get_tree().change_scene_to(load("res://scenes/ui/MainMenu.tscn"))


func on_lose()->void:
	pause_menu.disabled = true
	game_over.set_survived_text(wave_manager.waves_ended)
	
	if shop.visible:
		shop.disappear()
	
	if custom_death != "":
		game_over.get_node("Restart").disabled = true
		game_over.get_node("Restart").text = "Il n'y a pas d'issue"
	game_over.show()

#it will trigger the check even if no enemy are killed so no softlock
func _on_WaveManager_all_spawned():
	if check_if_no_enemy():
		on_level_win()
		return
	
	win_check_timer.start()


func _on_WinCheck_timeout():
	if not PLAYER.is_alive():
		print("game lost")
		win_check_timer.stop()
		return
	if check_if_no_enemy():
		win_check_timer.stop()
		if PLAYER.is_alive():
			on_level_win()
	else:
		print("Some enemies remain...")


func _on_player_dead()->void:
	on_lose()


func _on_Restart_pressed():
	restart()


func restart():
	print("\n---------------\n")
	print("Restart ", get_tree().current_scene.name, "\n")
	get_tree().paused = false
	var __ = get_tree().reload_current_scene()
