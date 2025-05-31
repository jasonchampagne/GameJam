class_name UICards extends CanvasLayer

signal another_hand
signal validate_hand

var button_is_pressed: bool = false
var button_pressed_time: float = 0.0
var action_interval: float = 0.01
var time_since_last_action: float = 0.0

var grid_maze: GridCaseMaze
var core_engine: CoreEngine
var hands_number: int = 0
var free_slots_value: int

@export var player: PlayerSprite

@onready var inprogress_zone: CardDropzone = %CardInProgress
@onready var card_drop_zone: CardDropzone = %CardDropzone
@onready var card_pile_ui: LinesCardPileUI = %LinesCardPileUI
@onready var score: Label = %Score
@onready var hands_number_label: Label = %HandsNumbers
@onready var free_slot: Label = %FreeSlots
@onready var amplis: Label = %Amplis

@onready var effect: CanvasLayer = %Effect
@onready var effect_rewind: ColorRect = %Effect/Rewind
@onready var card_display: CardDisplayText = %CardDisplayText


func _ready() -> void:
	card_pile_ui.pile_card_clicked.connect(pile_card_click.bind())
	free_slots_value = Globals.core_player.hand_size
	inprogress_zone.max_stack_display = free_slots_value
	effect.visible = true  #Globals.screen_effect
	card_pile_ui.draw(Globals.core_player.hand_size)
	score.text = tr("Score") + " : " + str(Globals.core_player.score)
	hands_number_label.text = tr("Hands Number") + " :  %s" % hands_number
	free_slot.text = tr("Free Slots") + " :  %s" % free_slots_value
	amplis.text = tr("Amplificators") + " :  0 "
	card_pile_ui.card_hovered.connect(self.card_hover.bind())


func card_hover(card_ui: LinesCardUI) -> void:
	card_display.card_to_display(card_ui.card_data)


func pile_card_click(card_ui: LinesCardUI) -> void:
	if inprogress_zone.drop_zone_full():
		return
	if card_pile_ui.get_card_dropzone(card_ui) == null:
		#card_pile_ui.set_card_pile(card_ui, CardPileUI.Piles.discard_pile)
		if !inprogress_zone.add_card_to_dropzone(card_ui):
			print_debug("plus de place")
			return
	else:
		print_debug("card in dropzone : ", card_ui.card_data.nice_name)
		return
	if core_engine.add_card(card_ui.card_data, Globals.core_player.current_dir) == null:
		card_to_hand(card_ui)
		print_debug("card in dropzone : ", card_ui.card_data.nice_name)
		return
	# if card_ui.card_data.type_card == Globals.TypeCard.AMPLIFICATEUR:
	# 	libEffects.lightning(card_ui.frontface)
	free_slots_value -= 1
	free_slot.text = tr("Free Slots") + " :  %s" % free_slots_value
	amplis.text = tr("Amplificators") + " :  %s " % core_engine.get_ampli_value()


func card_to_hand(card_in_drop: CardUI) -> void:
	card_pile_ui.set_card_pile(card_in_drop, CardPileUI.Piles.hand_pile)
	amplis.text = tr("Amplificators") + " :  %s " % core_engine.get_ampli_value()

	return


@warning_ignore("unused_parameter")

# gdlint: disable=unused-argument


func _input(event: InputEvent) -> void:
	for dir in Globals.INPUTS.keys():
		if Input.is_action_pressed(dir):
			print_debug("** button pressed ", dir)
			if player.moving:
				return
			if not button_is_pressed:
				button_is_pressed = true
				button_pressed_time = 0.0  # Réinitialise le temps lorsqu'on appuie sur le bouton
				time_since_last_action = 0.0  # Réinitialise l'intervalle d'action
				if dir != Globals.core_player.current_dir:
					Globals.core_player.set_dir(dir)
					player.set_dir(dir)
				else:
					var last_move_card: LinesCardUI = card_pile_ui.get_card_first_move_hand()
					# verifie que l'on ne sort pas du maze
					if (
						last_move_card != null
						and (
							last_move_card.card_data.action(
								Globals.core_player.current_dir, grid_maze
							)
							!= null
						)
					):
						card_pile_ui.card_click(last_move_card)
						#core_engine.add_card(last_move_card.card_data,dir)
					else:
						print_debug("en dehors du maze")
						print_debug("oups")
		elif button_is_pressed:  # Si le bouton est relâché
			button_is_pressed = false


func _card_to_discard(card_in_drop: CardUI) -> void:
	card_pile_ui.set_card_pile(card_in_drop, CardPileUI.Piles.discard_pile)
	return


func _on_button_focus() -> void:
	%ButtonFocusSound.play()


func _press_another_hand():
	core_engine.add_hands()
	reinit_free_slot()
	%ButtonClickSound.play()
	# discard all card in drop
	for card in card_drop_zone._held_cards:
		_card_to_discard(card)
	# put every cards in hand in drop
	for card in card_pile_ui.get_cards_in_hand():
		_card_to_discard(card)
	card_pile_ui.draw(Globals.core_player.hand_size)
	another_hand.emit()


func reinit_free_slot():
	free_slots_value = Globals.core_player.hand_size
	free_slot.text = tr("Free Slots") + " :  %s" % free_slots_value
	amplis.text = tr("Amplificators") + " :  %s " % core_engine.get_ampli_value()


func _press_validate_hand():
	%ButtonClickSound.play()
	core_engine.add_hands()
	reinit_free_slot()
	# discard all card in drop
	for card in inprogress_zone._held_cards:
		_card_to_discard(card)
	# put every cards in hand in drop
	card_pile_ui.draw(Globals.core_player.hand_size)
	hands_number += 1
	hands_number_label.text = tr("Hands Number") + " :  %s" % hands_number
	validate_hand.emit()


func rewind(activate: bool) -> void:
	if activate:
		%RewindSound.play()
		effect_rewind.visible = true
	else:
		effect_rewind.visible = false


@warning_ignore("unused_parameter")


func _unhandled_input(event):
	#print_debug(event)
	if player.moving:
		return
	# Effectue une action toutes les millisecondes
	if Input.is_action_pressed(Globals.ROLLBACK_BUTTON):
		if not button_is_pressed:
			button_is_pressed = true

		var last_card: CardUIData = core_engine.get_last_card()
		#get last direction and push is oposite
		self.rewind(true)
		if last_card != null:
			core_engine.rollback()
			var drop_pile_size: int = inprogress_zone.get_held_cards().size()
			if drop_pile_size > 0:
				var last_card_in_hand: CardUI = inprogress_zone.get_card_at(drop_pile_size - 1)
				card_to_hand(last_card_in_hand)
				free_slots_value += 1
				free_slot.text = tr("Free Slots") + " :  %s" % free_slots_value
		else:
			print_debug("no more forward possible")
		await get_tree().create_timer(Globals.TIME_ANOMATION_SPEED).timeout
		self.rewind(false)
	elif button_is_pressed:  # Si le bouton est relâché
		button_is_pressed = false
