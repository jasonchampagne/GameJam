class_name CardsCollection extends Node

signal level_won
signal level_lost
signal close

var level_state: LevelState
var back_button_state: bool = true
var total_cards: int = 0
var finding_cards: int = 0

@onready var back_button: Button = %BackButton
@onready var findings: Label = %Findings
@onready var card_display: CardDisplayText = %CardDisplayText


func _on_close_button_pressed() -> void:
	if back_button_state:
		level_lost.emit()
	else:
		close.emit()


func _on_win_button_pressed() -> void:
	level_won.emit()


func _on_button_focus(card: LinesCardUIData = null) -> void:
	%ButtonFocusSound.play()
	if card:
		card_display.card_to_display(card)


func add_card_button() -> void:
	for card: LinesCardUIData in Globals.core_deck.current_cards_collection:
		var frontface_texture: Texture
		total_cards += 1
		if GameState.has_card_discover(card):
			finding_cards += 1
		else:
			card = LinesCardUIData.new()
			card.nice_name = "UnknownCard"
			card.description = card.nice_name + "_desc"
			card.texture_path = Globals.DEFAULT_BACK_CARD_PATH

		frontface_texture = load(card.texture_path) as Texture

		var current_button: Button = Button.new()
		current_button.autowrap_mode = TextServer.AUTOWRAP_WORD
		current_button.icon = frontface_texture
		current_button.alignment = HORIZONTAL_ALIGNMENT_FILL
		current_button.mouse_entered.connect(func(): _on_button_focus(card))
		current_button.focus_entered.connect(_on_button_focus)

		%GridContainer.add_child(current_button)
		current_button.grab_focus()


func _init(back: bool = true) -> void:
	self.back_button_state = back


func _ready() -> void:
	level_state = GameState.get_level_state(scene_file_path)
	add_card_button()
	findings.text = tr("FINDINGS") + " : " + str(finding_cards) + " / " + str(total_cards)
