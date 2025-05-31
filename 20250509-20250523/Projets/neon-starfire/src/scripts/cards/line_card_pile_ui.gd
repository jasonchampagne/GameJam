class_name LinesCardPileUI extends CardPileUI

signal pile_card_clicked(card_ui: LinesCardUI)

var speed := 100.0
var line_points := []
var current_point_index := 0


func game_card_in_hand() -> bool:
	if self._hand_pile.size() > 0:
		return true
	return false


func number_card_in_hand() -> int:
	return self._hand_pile.size()


func get_cards_in_hand() -> Array[CardUI]:
	return self._hand_pile


func load_json_path():
	card_database = Globals.core_deck.get_card_database()
	# recupe tout les id / nice_name pour chaque carte
	card_collection = CoreDeck.get_deck_nice_name(Globals.core_player.current_cards_data_deck)


func _ready() -> void:
	super._ready()
	self.card_clicked.connect(self.card_click.bind())
	self.card_hovered.connect(self.card_hover.bind())


func card_hover(card_ui: CardUI) -> void:
	var card_data: LinesCardUIData = card_ui.card_data
	print_debug("display desc : " + card_data.nice_name)
	match card_data.type_card:
		Globals.TypeCard.MOVE:
			print_debug("move :" + str((card_data as MetaMOVE)._get_multip_move()))
		Globals.TypeCard.AMPLIFICATEUR:
			print_debug("move :" + str((card_data as AmpliX2).multiplicator_courrant))


func card_click(card_ui: LinesCardUI) -> void:
	pile_card_clicked.emit(card_ui)


func get_card_first_move_hand() -> LinesCardUI:
	for i in range(0, self._hand_pile.size()):
		var card: LinesCardUI = self.get_card_in_pile_at(CardPileUI.Piles.hand_pile, i)
		if card == null:
			break
		var card_data: LinesCardUIData = card.card_data
		if card_data.get_type_card() == Globals.TypeCard.MOVE:
			return card
	return null
