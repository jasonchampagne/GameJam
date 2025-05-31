@tool
class_name LinesCardUI extends CardUI

@onready var description: Label = %Description
@onready var points: Label = %Points


func _draw() -> void:
	self.size = Vector2(Globals.CARD_WIDH, Globals.CARD_WIDH)
	libEffects.create_border(self.frontface, Globals.color_type_card[card_data.get_type_card()], 40)


func _ready():
	if Engine.is_editor_hint():
		set_disabled(true)
		update_configuration_warnings()
		return
	connect("mouse_entered", _on_mouse_enter)
	connect("mouse_exited", _on_mouse_exited)
	connect("gui_input", _on_gui_input)
	if frontface_texture:
		frontface.texture = load(frontface_texture)  # texture_path
		backface.texture = load(backface_texture)
		custom_minimum_size = frontface.texture.get_size()
		pivot_offset = frontface.texture.get_size() / 2
		mouse_filter = Control.MOUSE_FILTER_PASS
	#description.text = (self.card_data as LinesCardUIData).description
	points.text = str((self.card_data as LinesCardUIData).power)
	#LibOptimize.remove_interact(frontface)
