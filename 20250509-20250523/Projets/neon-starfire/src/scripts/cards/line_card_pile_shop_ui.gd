class_name LinesCardPileShopUI extends CardPileUI

@warning_ignore("narrowing_conversion")
const DISPLAY_CARD_WIDTH: int = Globals.CARD_WIDH * 0.19  #122


@export var shop: Shop
@export var card_shop_zone: CardDropzone
@export var card_added_zone: CardDropzone

var speed := 100.0
var line_points := []
var current_point_index := 0

var size_cards: int


func load_json_path():
	# recupe tout les id / nice_name pour chaque carte
	card_database = Globals.core_deck.get_card_database()
	card_collection = Globals.core_deck.generate_collection_shop()
	size_cards = card_database.size()
	self.max_hand_spread = size_cards * DISPLAY_CARD_WIDTH
	self.max_hand_size = size_cards
	@warning_ignore("integer_division")
	self.card_ui_hover_distance = Globals.CARD_HEIGHT / 3


func _ready() -> void:
	super._ready()
 
	self.card_hovered.connect(shop.card_hover.bind())
	self.card_unhovered.connect(shop.card_unhover.bind())
	self.hand_pile_position = card_shop_zone.position
	self.discard_pile_position = card_added_zone.position
	card_shop_zone.layout = PilesCardLayouts.right
	self.card_clicked.connect(shop.card_pile_clicked.bind())
	for card in get_cards_in_pile(CardPileUI.Piles.draw_pile):
		
		set_card_pile(card, CardPileUI.Piles.hand_pile)


func set_card_to_deck(card_ui: LinesCardUI) -> void:
	self.max_hand_spread -= DISPLAY_CARD_WIDTH
	set_card_dropzone(card_ui, card_shop_zone)
