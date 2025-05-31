class_name Shop extends Control

signal level_won
const HOVER_ZOOM_CARD_FACTOR: float = 0.5

var current_cost: int = 0
@onready var card_shop_zone: CardDropzone = %CardShopZone
@onready var card_added_zone: CardDropzone = %CardAddedZone
@onready var card_pile: LinesCardPileShopUI = %LinesCardPileShopUI
@onready var cost_label: Label = %Cost
@onready var buy_button: Button = %BuyButton
@onready var money_label: Label = %Money
@onready var basket: Array[LinesCardUI] = []
@onready var card_display: CardDisplayText = %CardDisplayText


func _ready() -> void:
	card_shop_zone.max_stack_display = card_pile.size_cards
	card_shop_zone.stack_display_gap = 120
	_update_indicators()
	#finished.connect(get_parent().shop_finished)
	libEffects._add_rounded_border(money_label)
	libEffects._add_rounded_border(cost_label)


func card_add_to_basket(card_ui: LinesCardUI) -> void:
	var card_data: LinesCardUIData = card_ui.card_data
	if card_pile.get_card_dropzone(card_ui) == null:
		if current_cost + card_data.cost <= Globals.core_player.score:
			current_cost += card_data.cost
			cost_label.text = tr("Cost") + " : " + str(current_cost)
			card_pile.set_card_to_deck(card_ui)
			basket.append(card_ui)
		else:
			card_pile.set_card_pile(card_ui, CardPileUI.Piles.hand_pile)

	else:
		card_pile.set_card_pile(card_ui, CardPileUI.Piles.hand_pile)


func _update_indicators() -> void:
	money_label.text = tr("Have") + " : " + str(Globals.core_player.score)
	cost_label.text = tr("Cost") + " : " + str(current_cost)


func card_hover(card_ui: LinesCardUI) -> void:
	card_display.card_to_display(card_ui.card_data)
	card_ui.scale.x += HOVER_ZOOM_CARD_FACTOR
	card_ui.scale.y += HOVER_ZOOM_CARD_FACTOR


func card_unhover(card_ui: CardUI) -> void:
	card_ui.scale.x -= HOVER_ZOOM_CARD_FACTOR
	card_ui.scale.y -= HOVER_ZOOM_CARD_FACTOR


func card_pile_clicked(card_ui: LinesCardUI) -> void:
	if not basket.has(card_ui):
		card_add_to_basket(card_ui)
	else:
		card_remove_to_basket(card_ui)


func _on_button_focus() -> void:
	%ButtonFocusSound.play()


func buy_cards() -> void:
	%ButtonClickSound.play()
	print_debug(str(current_cost))
	for card_ui: LinesCardUI in basket:
		Globals.core_player.add_card_to_deck(card_ui.card_data)
		Globals.core_player.score -= card_ui.card_data.cost
		current_cost -= card_ui.card_data.cost
		card_pile.set_card_pile(card_ui, CardPileUI.Piles.draw_pile)
		_update_indicators()
	basket.clear()


func next_level() -> void:
	level_won.emit()


func card_remove_to_basket(card_ui: LinesCardUI) -> void:
	current_cost -= card_ui.card_data.cost
	cost_label.text = tr("Cost") + " : " + str(current_cost)
	basket.erase(card_ui)
	card_pile.set_card_pile(card_ui, CardPileUI.Piles.hand_pile)
	card_pile.draw()
