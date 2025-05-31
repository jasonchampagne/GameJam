class_name CardDropzoneDiscard extends CardDropzone


func add_card_to_dropzone(card: CardUI) -> bool:
	if !drop_zone_full():
		card_pile_ui._maybe_remove_card_from_any_piles(card)
		card_pile_ui._maybe_remove_card_from_any_dropzones(card)
		add_card(card)
		card_pile_ui.emit_signal("card_added_to_dropzone", self, card)
		card_pile_ui.reset_target_positions()
		return true
	return false


func _update_target_positions():
	for i in _held_cards.size():
		var card_ui = _held_cards[i]
		var target_pos = position

		# Ajouter un décalage horizontal basé sur la largeur de la carte
		var horizontal_offset = card_ui.size.x * 0.5

		if layout == CardPileUI.PilesCardLayouts.up:
			if i <= max_stack_display:
				target_pos.y -= i * stack_display_gap
			else:
				target_pos.y -= stack_display_gap * max_stack_display
		elif layout == CardPileUI.PilesCardLayouts.down:
			if i <= max_stack_display:
				target_pos.y += i * stack_display_gap
			else:
				target_pos.y += stack_display_gap * max_stack_display
		elif layout == CardPileUI.PilesCardLayouts.right:
			# Utiliser le décalage horizontal pour éviter le recouvrement
			target_pos.x += i * horizontal_offset
		elif layout == CardPileUI.PilesCardLayouts.left:
			# Utiliser le décalage horizontal pour éviter le recouvrement
			target_pos.x -= i * horizontal_offset

		# Définir la direction de la carte
		if card_ui_face_up:
			card_ui.set_direction(Vector2.UP)
		else:
			card_ui.set_direction(Vector2.DOWN)

		# Ajuster l'ordre d'affichage (z_index)
		if card_ui.is_clicked:
			card_ui.z_index = 3000 + i
		else:
			card_ui.z_index = i

		# Déplacer la carte et mettre à jour sa position cible
		card_ui.move_to_front()  # Doit être fait pour gérer l'ordre d'interaction
		card_ui.target_position = target_pos


func drop_zone_full() -> bool:
	return !get_total_held_cards() < max_stack_display


func card_ui_dropped(card_ui):
	card_pile_ui.set_card_pile(card_ui, CardPileUI.Piles.discard_pile)
	print_debug("drop")
