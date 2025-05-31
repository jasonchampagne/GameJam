extends Node


onready var material = owner.material

export var blink_duration : float = 0.5



func blink()->void:
	pass
#	var tween := get_tree().create_tween()
	
#	var __ = tween.tween_method(self, "set_blink_intensity", 1.0, 0.0, blink_duration)
	
#	tween.play()




func set_blink_intensity(value : float)->void:
	material.set_shader_param("blink_intensity", value)
