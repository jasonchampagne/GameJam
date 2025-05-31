class_name ResultActionCard extends Resource

var target: Vector2i
var moves: Array[String] = []
var point: int = 0
var current_maze: GridCaseMaze
var sound: String = ""
var graphic_effect: String = ""


func _init() -> void:
	moves = []
