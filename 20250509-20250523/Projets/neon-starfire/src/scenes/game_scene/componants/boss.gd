class_name Boss extends Area2D

@export var camera: ShakeCamera
@export var uicards: UICards

@onready var ray: RayCast2D = $RayCast2D
@onready var CorrectSound: AudioStream = preload("res://assets/sounds/moves/move_metal.wav")
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D


func move_boss(end_pos: Vector2 = Vector2.ZERO, loop: bool = true) -> void:
	var tween = create_tween()
	var start_pos = position
	if end_pos == Vector2.ZERO:
		end_pos = Vector2(position.x, position.y + 200)
	tween.tween_property(self, "position", end_pos, 1.0).set_trans(Tween.TRANS_SINE).set_ease(
		Tween.EASE_IN_OUT
	)
	tween.tween_property(self, "position", start_pos, 1.0).set_trans(Tween.TRANS_SINE).set_ease(
		Tween.EASE_IN_OUT
	)
	if loop:
		tween.set_loops()  # Loop indefinitely

	animated_sprite_2d.play("idle")
	animated_sprite_2d.sprite_frames.set_animation_loop("idle", true)


func attack() -> void:
	%AudioStreamPlayer2D.play()
	#move_boss(attack_position, false)
	animated_sprite_2d.play("ball")
	animated_sprite_2d.sprite_frames.set_animation_loop("ball", false)
	Globals.core_player.score = Globals.core_player.score / 2
	uicards.score.text = "Score: %s" % Globals.core_player.score
	camera.add_trauma(0.5)
	camera.shake()


func destroyed() -> void:
	animated_sprite_2d.play("is_destroy")
	animated_sprite_2d.sprite_frames.set_animation_loop("is_destroy", false)


func _ready() -> void:
	animated_sprite_2d.animation = "idle"
	animated_sprite_2d.play()
	animated_sprite_2d.sprite_frames.set_animation_loop("idle", true)
