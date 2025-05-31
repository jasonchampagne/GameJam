class_name PlayerSprite
extends Area2D

signal one_step(postion: Vector2i, dir: String, forward: bool)
const REF_SUFFIX: String = "_rev"

var animation_in_progress: bool = false
var moving: bool = false
var tween: Tween

@onready var ray: RayCast2D = $RayCast2D
@onready var CorrectSound: AudioStream = preload("res://assets/sounds/moves/move_metal.wav")
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D


func custom_connect(level: Node2D):
	self.one_step.connect(level._on_player_one_step.bind())


func get_position_i() -> Vector2i:
	return Vector2i(int(self.position.x), int(self.position.y))


func set_dir(dir) -> void:
	#animated_sprite_2d.play(dir)
	animated_sprite_2d.animation = dir
	animated_sprite_2d.frame = 0


func _add_anim_frames(
	x_coords: int,
	sprite_frames: SpriteFrames,
	full_spritesheet: Texture,
	name_anim: String = Globals.SPRITE_SHEET_MAPING[x_coords],
	reverse: bool = false,
	num_columns: int = Globals.SPRITE_SHEET_MAPING.size(),
):
	sprite_frames.remove_animation(name_anim)
	sprite_frames.add_animation(name_anim)
	sprite_frames.set_animation_loop(name_anim, false)
	var y_range = range(int(Globals.TEXTURE_SIZE.y / Globals.SPRITE_SIZE.y))
	if reverse:
		y_range = range(int(Globals.TEXTURE_SIZE.y / Globals.SPRITE_SIZE.y) - 1, 0)
	for y_coords in y_range:
		var frame_tex := AtlasTexture.new()
		frame_tex.atlas = full_spritesheet
		frame_tex.region = Rect2(
			Vector2(x_coords, y_coords) * Globals.SPRITE_SIZE, Globals.SPRITE_SIZE
		)
		sprite_frames.add_frame(name_anim, frame_tex, y_coords * num_columns + x_coords)


func _ready():
	var sprite_frames: SpriteFrames = SpriteFrames.new()
	var full_spritesheet: Texture = load(Globals.core_player.sprite_tile_sheet)
	# var num_columns: int = int(texture_size.x / sprite_size.x)

	# ajout du default
	self._add_anim_frames(0, sprite_frames, full_spritesheet, "default")

	for x_coords in Globals.SPRITE_SHEET_MAPING:
		self._add_anim_frames(x_coords, sprite_frames, full_spritesheet)
		self._add_anim_frames(
			x_coords,
			sprite_frames,
			full_spritesheet,
			Globals.SPRITE_SHEET_MAPING[x_coords] + REF_SUFFIX,
			true
		)
	animated_sprite_2d.frames = sprite_frames


func _on_tween_completed():
	animation_in_progress = false
	tween.is_queued_for_deletion()


func move(dir: String, forward: bool = false) -> void:
	# check with the hand
	ray.target_position = Globals.INPUTS[dir] * Globals.TILE_SIZE
	ray.force_raycast_update()
	if !ray.is_colliding():
		if !$AudioStreamPlayer2D.is_playing():
			$AudioStreamPlayer2D.stream = CorrectSound
			$AudioStreamPlayer2D.play()
		if forward:
			animated_sprite_2d.play(Globals.OPPOSITE_DIR[dir] + REF_SUFFIX)
		else:
			animated_sprite_2d.play(dir)
		tween = create_tween()
		tween.finished.connect(_on_tween_completed)  # Connecte le signal à la fonction de callback
		animation_in_progress = true
		(
			tween
			. tween_property(
				self,
				"position",
				self.position + Globals.INPUTS[dir] * Globals.TILE_SIZE,
				Globals.TIME_ANOMATION_SPEED
			)
			. set_trans(Tween.TRANS_SINE)
		)
		moving = true
		one_step.emit(self.position, forward)
		await tween.finished
		moving = false
