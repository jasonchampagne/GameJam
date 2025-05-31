extends Control


onready var title_label := $Label
onready var survived_label := $Survived
onready var animation_player := $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func show():
	print("game over")
	animation_player.play("appear")
	title_label.modulate.a = 0
	survived_label.rect_position.x = -2000
	.show()
	
	



func set_survived_text(count : int)->void:
	var plural : String = "s" if count > 1 else ""
	survived_label.text = "A survécu à %d vague%s" % [count, plural]
