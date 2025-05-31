class_name GameState
extends Resource

const STATE_NAME: String = "GameState"
const FILE_PATH = "res://scripts/game_state.gd"

@export var level_states: Dictionary = {}
@export var max_level_reached: int
@export var current_level: int
@export var times_played: int
@export var current_cards_collection: Array[String] = []
@export var current_cards_collection_first_look: Array[String] = []


static func get_level_state(level_state_key: String) -> LevelState:
	var game_state := get_game_state()
	if level_state_key.is_empty():
		return
	if level_state_key in game_state.level_states:
		return game_state.level_states[level_state_key]
	var new_level_state := LevelState.new()
	game_state.level_states[level_state_key] = new_level_state
	return new_level_state


static func card_discover(card_data: LinesCardUIData) -> void:
	var game_state := get_game_state()
	if not game_state:
		GlobalState.open()
		game_state = get_game_state()
	if !has_card_discover(card_data):
		game_state.current_cards_collection.append(card_data.nice_name)
		GlobalState.save()


static func has_card_discover(card_data: LinesCardUIData) -> bool:
	var game_state := get_game_state()
	if not game_state:
		return false
	return game_state.current_cards_collection.has(card_data.nice_name)


static func has_card_look(card_data: LinesCardUIData) -> bool:
	var game_state := get_game_state()
	if not game_state:
		return false
	var result = game_state.current_cards_collection_first_look.has(card_data.nice_name)
	if !result:
		game_state.current_cards_collection_first_look.append(card_data.nice_name)
		GlobalState.save()
	return result


static func has_game_state() -> bool:
	return GlobalState.has_state(STATE_NAME)


static func get_game_state() -> GameState:
	return GlobalState.get_state(STATE_NAME, FILE_PATH)


static func get_current_level() -> int:
	var game_state := get_game_state()
	if not game_state:
		return 0
	return game_state.current_level


static func get_max_level_reached() -> int:
	var game_state := get_game_state()
	if not game_state:
		return 0
	return game_state.max_level_reached


static func level_reached(level_number: int) -> void:
	var game_state := get_game_state()
	if not game_state:
		return
	game_state.max_level_reached = max(level_number, game_state.max_level_reached)
	game_state.current_level = level_number
	GlobalState.save()


static func set_current_level(level_number: int) -> void:
	var game_state := get_game_state()
	if not game_state:
		return
	game_state.current_level = level_number
	GlobalState.save()


static func start_game() -> void:
	var game_state := get_game_state()
	if not game_state:
		return
	game_state.times_played += 1
	GlobalState.save()
