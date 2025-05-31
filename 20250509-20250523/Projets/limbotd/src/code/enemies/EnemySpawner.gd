extends Node2D


signal spawned_all


export(PackedScene) var scene : PackedScene = preload("res://scenes/enemies/basic/Enemy1.tscn")
export(NodePath) var path_path : String = ""

export var number : int = 1
export var delay : float = 0.5
export var time_before_start : float = 0


onready var path := get_node(path_path)
onready var timer := $Timer
onready var before_start_timer := $BeforeStart

var spawned : int = 0

var is_started : bool = false
var is_finished : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	before_start_timer.one_shot = true
	if time_before_start <= 0:
		return
	
	before_start_timer.wait_time = time_before_start
	


func start()->void:
	is_started = true
	
	if time_before_start <= 0:
		start_spawning()
		return
	before_start_timer.start()


func start_spawning()->void:
	if number > 1:
		timer.wait_time = delay
		timer.start()
		spawn_one()
	elif number == 1:
		spawn_one()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func spawn_one()->void:
	var enemy = scene.instance()
	
	enemy.global_position = path.curve.get_point_position(0)
	path.add_child(enemy)
	
	
	spawned += 1


func _on_Timer_timeout():
	if number <= 1:
		return
	spawn_one()
	
	if spawned >= number:
		timer.stop()
		is_finished = true
		emit_signal("spawned_all")
		queue_free()


func _on_BeforeStart_timeout():
	start_spawning()
