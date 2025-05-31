extends Control





onready var play_button := $Main/Buttons/Play
onready var labels := $Main/Buttons

onready var fade_rect := $ColorRect
onready var main_menu := $Main


onready var level_select := $LevelSelect
onready var credits := $Credits


var selected_index : int = 0
var disabled : Array = [1, 2]



# Called when the node enters the scene tree for the first time.
func _ready():
	fade_rect.visible = false
	credits.hide()
	level_select.hide()
	main_menu.show()
	select_label(0)
#	disable_title()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func select_label(index : int)->void:
	for i in range(labels.get_child_count()):
		var label : Label = labels.get_child(i)
		
		if i in disabled:
			label.modulate = Color(0.9, 0.9, 0.9, 0.75)
		if i == index:
			label.theme_type_variation = ""
		else:
			label.theme_type_variation = "ButtonUnselected"



func handle_selection()->void:
	var offset : int = 0
	if Input.is_action_just_pressed("ui_up"):
		offset = -1
	elif Input.is_action_just_pressed("ui_down"):
		offset = 1
	else:
		return
	
	selected_index = (selected_index + offset) % labels.get_child_count()
	while selected_index in disabled:
		selected_index = (selected_index + offset) % labels.get_child_count()
		
	if selected_index < 0:
		selected_index = labels.get_child_count() - 1
	select_label(selected_index)


func start_level(level)->void:
	print("Starting level")
	fade_rect.visible = true
	fade_rect.modulate = Color(0, 0, 0, 0)
	
	var tween = get_tree().create_tween()
	var __ = tween.tween_property(fade_rect, "modulate", Color.black, 0.5)
	tween.play()
	
	yield(tween, "finished")

	var _err = get_tree().change_scene_to(level)


func on_play()->void:
	main_menu.hide()
	disable_main()
	level_select.appear()


func on_credits()->void:
	main_menu.hide()
	credits.show()


func on_exit()->void:
	print("Quit game")
	get_tree().quit()


func is_mouse_click_valid(index : int, event)->bool:
	if index in disabled:
		return false
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		select_label(index)
		return true
	
	return false


func _unhandled_key_input(_event):
	handle_selection()
	if Input.is_action_just_pressed("ui_cancel"):
		credits.visible = false
		main_menu.visible = true
		enable_main()
	if Input.is_action_just_pressed("ui_accept"):
		match selected_index:
			0:
				on_play()
			3:
				on_credits()
			4:
				on_exit()


func disable_main()->void:
	selected_index = -1
	disabled = range(labels.get_child_count())


func enable_main()->void:
	selected_index = 0
	select_label(0)
	disabled = [1, 2]





func _on_Play_gui_input(event):
	if is_mouse_click_valid(0, event):
		on_play()


func _on_Extra_gui_input(event):
	if is_mouse_click_valid(1, event):
		print("Extra !")


func _on_Settings_gui_input(event):
	if is_mouse_click_valid(2, event):
		print("Settings")


func _on_Credits_gui_input(_event):
	print("Credits")


func _on_Exit_gui_input(event):
	if is_mouse_click_valid(3, event):
		on_exit()


func _on_LevelItem_level_chosen(scene):
	start_level(scene)


func _on_LevelSelect_closed():
	level_select.disappear()
	main_menu.visible = true
	enable_main()



