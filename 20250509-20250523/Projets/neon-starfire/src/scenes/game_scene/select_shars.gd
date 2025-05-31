extends Node

signal level_won
signal level_lost

var level_state: LevelState


func _on_lose_button_pressed() -> void:
	level_lost.emit()


func _on_win_button_pressed() -> void:
	level_won.emit()


func _set_character(name_file: String) -> void:
	%ButtonClickSound.play()
	var core_deck: CoreDeck = CoreDeck.new(Globals.JSON_CARD_DATABASE_PATH)
	Globals.core_player = CorePlayer.new(name_file, core_deck.create_deck())
	var game_scene_path: String = "res://scenes/game_scene/game_ui.tscn"
	%BackgroundMusicPlayer.stop()
	SceneLoader.load_scene(game_scene_path)


func _on_button_focus(char_name: String) -> void:
	%ButtonFocusSound.play()
	%CharTitle.text = tr(char_name + "_title")
	%CharDesc.text = tr(char_name + "_desc")


func add_char_button(dir_path: String) -> void:
	var dir := DirAccess.open(dir_path)
	if dir == null:
		printerr("Could not open folder")
		return
	# Hook to avoid any issue with the file system during the export
	#dir.list_dir_begin()
	var list_files = {}
	if dir_path.ends_with("Females/"):
		list_files = Globals.NAME_CHARS_F.keys()
	else:
		list_files = Globals.NAME_CHARS_M.keys()

	for file: String in list_files:
		if file.ends_with(".png") && (file.begins_with("F_") or file.begins_with("M_")):
			var resource := load(dir_path + "/" + file) as Texture
			if resource == null:
				printerr("Could not load resource: " + file)
				continue
			var atlas_texture: AtlasTexture = AtlasTexture.new()
			atlas_texture.atlas = resource
			atlas_texture.region = Rect2(Vector2(0, 0), Globals.SPRITE_SIZE)

			# Create a VBoxContainer to stack icon above text
			var vbox := VBoxContainer.new()
			vbox.alignment = BoxContainer.ALIGNMENT_CENTER

			var icon_texture_rect := TextureRect.new()
			icon_texture_rect.texture = atlas_texture
			icon_texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			icon_texture_rect.custom_minimum_size = Globals.SPRITE_SIZE * 4

			var current_button: Button = Button.new()
			current_button.text = Globals.NAME_CHARS[file]
			current_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
			current_button.custom_minimum_size = Vector2(Globals.SPRITE_SIZE.x * 3, 48)
			current_button.pressed.connect(Callable(self, "_set_character").bind(file))
			current_button.mouse_entered.connect(func(): _on_button_focus(current_button.text))
			current_button.focus_entered.connect(func(): _on_button_focus(current_button.text))

			vbox.add_child(icon_texture_rect)
			vbox.add_child(current_button)
			%HBoxContainerChars.add_child(vbox)
			current_button.grab_focus()


func _ready() -> void:
	level_state = GameState.get_level_state(scene_file_path)
	self.add_char_button("res://assets/sprites/Females/")
	self.add_char_button("res://assets/sprites/Males/")
	libEffects._add_rounded_border(%CharTitle)
	libEffects._add_rounded_border(%CharDesc)


func _on_tutorial_button_pressed() -> void:
	var game_scene_path: String = "res://scenes/menus/main_menu/main_menu_with_animations.tscn"
	%BackgroundMusicPlayer.stop()
	SceneLoader.load_scene(game_scene_path)


func _on_color_picker_button_color_changed(color: Color) -> void:
	%BackgroundColor.color = color
	level_state.color = color
	GlobalState.save()
