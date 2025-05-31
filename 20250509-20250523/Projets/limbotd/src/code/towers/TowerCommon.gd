extends Node2D


const N_POINTS = 100


onready var upgrade_effect := $UpgradeEffect
onready var line := $Line2D

var previous_range : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	line.clear_points()
	previous_range = owner.tower_range
	line.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	upgrade_effect.rotation = -get_parent().rotation


func on_upgrade()->void:
	upgrade_effect.emitting = true


func set_range()->void:
	var tower_range : float = owner.tower_range
	
	if tower_range == previous_range and len(line.points) > 0:
		return
	
	previous_range = tower_range
	line.clear_points()
	
	var angle : float = ((2 * PI) / N_POINTS)
	for i in range(N_POINTS):
		
		var vec := Vector2(0, tower_range - line.width / 2).rotated(angle * i)
		line.add_point(vec)
	line.add_point(Vector2(0, tower_range - line.width / 2))


func show_range(is_showing : bool)->void:
	line.visible = is_showing
	if not is_showing:
		return
	
	set_range()
