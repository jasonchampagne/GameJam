class_name CoreEngine
extends Resource

signal update_score(score: int)
signal update_maze(result_card: ResultActionCard)
signal update_player_move(moves: Array[String], forward: bool)

const MOVES_IDX_IN_HAND: int = 0
const CASES_IDX_IN_HAND: int = 1
const CARDS_IDX_IN_HAND: int = 2

var current_ampls: Array[LinesCardUIData] = []
var current_player: Array[LinesCardUIData] = []
var _wait_cards: Array[LinesCardUIData] = []

var _histo_total_move: Array[Array] = []
var _histo_move: Array[Array] = []
var _histo_case_maze: Array[CaseMaze] = []
var _histo_card: Array[LinesCardUIData] = []
var _hands: Array[Array] = []

var _maze: GridCaseMaze


func _init(maze: GridCaseMaze) -> void:
	self._maze = maze


func set_current_maze(maze: GridCaseMaze) -> void:
	self._maze = maze


func init_start(target: CaseMaze) -> void:
	self._histo_case_maze.append(target)


func _add_to_score(add: int) -> void:
	update_score.emit(add)


func rollback() -> ResultActionCard:
	var card: LinesCardUIData = self._histo_card.pop_back()
	var dirs: Array[String] = []
	if _histo_move.size() > 0:
		dirs = _histo_move.pop_back()
		_histo_total_move.pop_back()
	var dir: String = ""
	if dirs.size() > 0:
		dir = dirs[-1]
	var result_card: ResultActionCard = ResultActionCard.new()
	if card != null:
		if card.type_card == Globals.TypeCard.AMPLIFICATEUR:
			current_ampls.pop_back()
		else:
			result_card = card.reverse(dir, _maze)
			if card.type_card == Globals.TypeCard.MAZE or card.type_card == Globals.TypeCard.SCORE:
				update_maze.emit(result_card)
			if card.type_card == Globals.TypeCard.MOVE:
				update_player_move.emit(result_card.moves, true)
			if self._histo_case_maze.size() > 0:
				self._histo_case_maze.pop_back()
	self._add_to_score(result_card.point)

	return result_card


func check_last_correct_move_card(cards_pile: LinesCardPileUI, dir: String = "") -> LinesCardUI:
	for card in cards_pile.get_cards_in_hand():
		var card_data: LinesCardUIData = card.card_data
		if card_data.type_card == Globals.TypeCard.MOVE:
			var result_card: ResultActionCard = card_data.action(dir, _maze)
			card_data.reverse(dir, _maze)
			if result_card != null && _check_card_move(result_card):
				return card as LinesCardUI
	return null


func _check_card_move(result_card: ResultActionCard) -> bool:
	var player_position: Vector2i = _maze.get_player_position()
	for dir in result_card.moves:
		player_position = player_position + Globals.INPUTS_I[dir]
		if (
			player_position.x > _maze.get_weight()
			|| player_position.x < 0
			|| player_position.y > _maze.get_hight()
			|| player_position.y < 0
			|| _maze.get_type_case(player_position.x, player_position.y) == Globals.TypeCase.CASEMUR
		):
			return false
	return true

func get_ampli_value() -> int:
	var value: int= 0
	if current_ampls.size() > 0 :
		var current_ampl: LinesCardUIData = current_ampls[current_ampls.size()-1]
		value = current_ampl.multiplicator_courrant
	return value

func apply_appli(
	card: LinesCardUIData, dir: String = "", is_reverse: bool = false
) -> Array[LinesCardUIData]:
	var copy_old_amplis = current_ampls.duplicate(true)
	while current_ampls.size() > 0:
		#TODO check if the correct order to process ampl
		var current_ampl: LinesCardUIData = current_ampls.pop_back()
		current_ampl.set_target_card(card)
		if is_reverse:
			current_ampl.reverse(dir, _maze)
		else:
			current_ampl.action(dir, _maze)
	return copy_old_amplis


func add_card(card: LinesCardUIData, dir: String = "") -> ResultActionCard:
	var result_card: ResultActionCard = ResultActionCard.new()
	var old_list_amplis: Array[LinesCardUIData] = apply_appli(card, dir)
	if card.type_card == Globals.TypeCard.AMPLIFICATEUR:
		current_ampls = old_list_amplis
		current_ampls.append(card)
		print_debug("size of ampli:" + str(current_ampls.size()))
	else:
		result_card = card.action(dir, _maze)
		if result_card != null && _check_card_move(result_card):
			if card.type_card == Globals.TypeCard.MOVE:
				update_player_move.emit(result_card.moves, false)
			if card.type_card == Globals.TypeCard.PLAYER:
				current_player.append(card)
			if card.type_card == Globals.TypeCard.SCORE:
				#card.set_score(result_card.point)
				update_maze.emit(result_card)
			if card.type_card == Globals.TypeCard.MAZE:
				update_maze.emit(result_card)

		else:
			#soucis de move il faut sortir
			current_ampls = old_list_amplis
			old_list_amplis = apply_appli(card, dir, true)
			current_ampls = old_list_amplis
			card.reverse(dir, _maze)
			return null
	self._histo_card.append(card)
	self._histo_move.append(result_card.moves)
	self._histo_total_move.append(result_card.moves)
	self._histo_case_maze.append(_maze.get_case_maze(result_card.target.x, result_card.target.y))
	self._add_to_score(result_card.point)
	return result_card


func add_hands() -> void:
	var current_hands: Array = []
	current_hands.insert(MOVES_IDX_IN_HAND, self._histo_move)
	current_hands.insert(CASES_IDX_IN_HAND, self._histo_case_maze)
	current_hands.insert(CARDS_IDX_IN_HAND, self._histo_card)
	self._hands.append(current_hands)
	# purge existing
	_histo_move = []
	_histo_case_maze = []
	_histo_card = []


func get_last_case() -> CaseMaze:
	if _histo_case_maze.size() > 0:
		return self._histo_case_maze[-1]
	return null


func get_all_moves() -> Array[String]:
	var dirs: Array[String] = []
	for row in _histo_total_move:
		for dir in row:
			dirs.append(dir)
	return dirs


func get_last_move() -> String:
	var last_card: LinesCardUIData = self.get_last_card()
	if last_card != null:
		var dirs: Array[String] = _histo_total_move[-1]
		return dirs[-1]
	if _hands.size() > 0:
		#return the last of the other hand
		var last_hands: Array = _hands[-1]
		return last_hands[MOVES_IDX_IN_HAND][-1]
	return ""


func get_last_card() -> LinesCardUIData:
	if _histo_card.size() > 0:
		return self._histo_card[-1]
	if _hands.size() > 0:
		#return the last of the other hand
		var last_hands: Array = _hands[-1]
		if last_hands[CARDS_IDX_IN_HAND].size() > 0:
			return last_hands[CARDS_IDX_IN_HAND][-1]
	if _wait_cards.size() > 0:
		var return_card: LinesCardUIData = self._wait_cards.pop_back()
		return return_card
	return null
