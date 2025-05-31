extends Node
class_name PathFollowComponent


export(NodePath) var path_path : String = "../.."
export var base_speed : float = 75
export var leniency : float = 5
export var rand_length : float = 20
export var look_at_path : bool = false


onready var path : Path2D = get_node(path_path)

var target_point : Vector2 = Vector2.ZERO
var current_point_index : int = 0

var path_size : int = 0
var offset : Vector2 = Vector2.ZERO

onready var speed : float = base_speed
var slow_amount : float = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	initialize()
	look_at_dest()


func initialize()->void:
	owner.global_position = path.curve.get_baked_points()[0]
	path_size = len(path.curve.get_baked_points())
	target_point = path.curve.get_baked_points()[1]
	
	if offset == null:
		offset = Vector2(
				rand_range(-rand_length, rand_length),
				rand_range(-rand_length, rand_length)
			)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	speed = clamp(base_speed * (1.0 - slow_amount), 0.0, INF)
	move(delta)
	look_at_dest()
	slow_amount = 0.0


func set_slow_amount(amount : float)->void:
	if amount > slow_amount:
		slow_amount = amount


func look_at_dest()->void:
	if look_at_path:
		
		owner.look_at(target_point)


func move(delta)->void:
	if target_point.distance_to(owner.global_position) <= leniency:
		current_point_index += 1
		if current_point_index >= path_size:
			owner.on_end_of_path()
			return
		target_point = path.curve.get_baked_points()[current_point_index] + offset
#		print(target_point)
	
	
	owner.global_position += owner.global_position.direction_to(target_point) * (
		speed * delta)

