extends PauseMenu

@export var cards_collection_packed_scene: PackedScene
@export var help_packed_scene: PackedScene

func _ready():
	var menu_buttons = %MenuButtons.get_children()
	for button in menu_buttons:
		if button.has_signal("focus_entered"):
			button.connect("focus_entered", self._on_button_focus.bind())
		if button.has_signal("mouse_entered"):
			button.connect("mouse_entered", self._on_button_focus.bind())
	%CardsCollection.connect("pressed", self._on_cards_collection_button_pressed.bind())


func _on_cards_collection_button_pressed() -> void:
	open_cards_collection_menu()

func _on_help_button_pressed() -> void:
	open_help_menu()
	
func open_help_menu() -> void:
	var help_scene := help_packed_scene.instantiate()
	add_child(help_scene)
	_disable_focus.call_deferred()
	await help_scene.tree_exiting
	_enable_focus.call_deferred()

func open_cards_collection_menu() -> void:
	var cards_collection_scene = cards_collection_packed_scene.instantiate()
	cards_collection_scene.back_button_state = false
	cards_collection_scene.connect("close", self.close.bind())
	add_child(cards_collection_scene)
	_disable_focus.call_deferred()
	await cards_collection_scene.tree_exiting
	_enable_focus.call_deferred()


func close() -> void:
	_scene_tree.paused = _initial_pause_state
	Input.set_mouse_mode(_initial_mouse_mode)
	if is_instance_valid(_initial_focus_control) and _initial_focus_control.is_inside_tree():
		_initial_focus_control.focus_mode = _initial_focus_mode
		_initial_focus_control.grab_focus()
	queue_free()


func _on_button_focus() -> void:
	%ButtonFocusSound.play()


func _press_another_hand():
	%ButtonClickSound.play()
