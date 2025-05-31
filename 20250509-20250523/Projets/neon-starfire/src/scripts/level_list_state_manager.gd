extends LevelListManager


func _load_level_complete_screen_or_next_level() -> void:
	if level_won_scene:
		var instance = level_won_scene.instantiate()
		get_tree().current_scene.add_child(instance)
		_try_connecting_signal_to_node(instance, &"continue_pressed", _load_next_level)
		_try_connecting_signal_to_node(instance, &"restart_pressed", _advance_and_reload)
		_try_connecting_signal_to_node(instance, &"main_menu_pressed", _advance_and_load_main_menu)
	else:
		_load_next_level()


func load_current_level() -> void:

	level_list_loader.load_level(get_current_level_id())


func is_on_last_level() -> bool:
	# Stop current sound on Music bus and play another mp3
	var result: bool = get_current_level_id() + 1 >= level_list_loader.files.size()
	# pour lancer la musique de fin
	if get_current_level_id() + 1  == level_list_loader.files.size() - 1  :
		var music_player = get_node_or_null("%BackgroundMusicPlayer")
		if music_player :
			music_player.stop()
			music_player.stream = load("res://assets/sounds/musics/credits_ending_Vortex.mp3")
			music_player.play()
	return result


func is_on_shop_level() -> bool:
	# shop levels are even
	return !(get_current_level_id() % 2 == 0)


#func _on_level_won():
#if is_on_shop_level():
#Globals.current_maze_height += 1
#Globals.current_maze_width += 1
#_load_next_level()
#if is_on_last_level():
#_load_win_screen_or_ending()
#else:
#_load_next_level()
##_load_level_complete_screen_or_next_level()
func _on_level_won():
	Globals.current_maze_height += 1
	Globals.current_maze_width += 1
	if is_on_last_level():
		_load_win_screen_or_ending()
	else:
		_load_level_complete_screen_or_next_level()


func set_current_level_id(value: int) -> void:
	super.set_current_level_id(value)
	GameState.level_reached(value)


func get_current_level_id() -> int:
	current_level_id = GameState.get_current_level() if force_level == -1 else force_level
	return current_level_id


func _advance_level() -> bool:
	var advanced := super._advance_level()
	GameState.set_current_level(current_level_id)
	return advanced
