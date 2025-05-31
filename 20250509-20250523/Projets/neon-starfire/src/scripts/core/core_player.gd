class_name CorePlayer extends Resource

var current_dir: String = "ui_down"
var current_name: String = "Lindsay"
var sprite_tile_sheet: String = "res://assets/sprites/Females/F_06.png"
var score: int = 0
var hand_size: int
var deck_size: int
var drop_size: int
var rewind_count: int

var current_cards_data_deck: Array[LinesCardUIData]

var current_histo_move: Array[Vector2i]


func _init(current_sprite_tile_sheet: String, cards_data_deck: Array[LinesCardUIData]) -> void:
	if current_sprite_tile_sheet.begins_with("F_"):
		self.sprite_tile_sheet = "res://assets/sprites/Females/" + current_sprite_tile_sheet
	else:
		self.sprite_tile_sheet = "res://assets/sprites/Males/" + current_sprite_tile_sheet
	self.current_name = Globals.NAME_CHARS[current_sprite_tile_sheet]
	hand_size = Globals.HAND_SIZE
	drop_size = Globals.DROP_SIZE
	for card: LinesCardUIData in cards_data_deck:
		add_card_to_deck(card)
	current_histo_move = []


func update_score(value: int) -> void:
	score += value


func add_card_to_deck(card: LinesCardUIData) -> void:
	GameState.card_discover(card)
	current_cards_data_deck.append(card)


func add_move(move: Vector2i) -> void:
	current_histo_move.append(move)


func get_rewind_count() -> int:
	return rewind_count


func update_rewind_count(count: int) -> void:
	rewind_count += count


func get_last_move() -> Vector2i:
	return current_histo_move.get(current_histo_move.size() - 1)


func remove_card_to_deck(card: LinesCardUIData) -> void:
	var idx: int = current_cards_data_deck.find(card)
	current_cards_data_deck.remove_at(idx)


func set_dir(pressed_dir: String) -> void:
	self.current_dir = pressed_dir


func set_current_name(name: String) -> void:
	self.current_name = name
