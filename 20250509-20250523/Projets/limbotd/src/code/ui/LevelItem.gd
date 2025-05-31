extends PanelContainer

signal level_chosen(scene)

export var text : String = "<Level name>"
export(Texture) var texture : Texture
export(PackedScene) var level : PackedScene

onready var label := $VBoxContainer/LevelName
onready var texture_rect := $VBoxContainer/TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	theme_type_variation = "PanelContUnselected"
	label.text = text
	texture_rect.texture = texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_focus(left, right)->void:
	if left != null:
		focus_neighbour_left = "../" + left.name
	if right != null:
		focus_neighbour_right = "../" + right.name


func _on_LevelItem_focus_entered():
	theme_type_variation = ""


func _on_LevelItem_focus_exited():
	theme_type_variation = "PanelContUnselected"


func _on_LevelItem_gui_input(event):
	if Input.is_action_just_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed):
		emit_signal("level_chosen", level)
