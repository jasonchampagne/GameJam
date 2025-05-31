class_name StageBoss extends StageSimple

@onready var boss = %Boss


func _ready() -> void:
	super._ready()
	%UICards.connect("another_hand", boss.attack.bind())
	%UICards.connect("validate_hand", boss.attack.bind())

	boss.move_boss()
