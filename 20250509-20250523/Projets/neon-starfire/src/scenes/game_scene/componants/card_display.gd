class_name CardDisplayText extends Node2D

@onready var card_title_desc: Label = %CardDescTitle
@onready var card_desc: Label = %CardDescContent


func _ready():
	libEffects._add_rounded_border(card_title_desc)
	libEffects._add_rounded_border(card_desc)


func card_to_display(card_data: LinesCardUIData) -> void:
	card_title_desc.text = tr(card_data.nice_name)
	card_desc.text = tr(card_data.description)
