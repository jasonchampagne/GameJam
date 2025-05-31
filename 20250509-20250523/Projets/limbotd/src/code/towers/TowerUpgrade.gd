extends Resource
class_name TowerUpgrade


export var cost : int = 100
export var new_damage : float = 10
export var new_range : int

var fire_rate : float = -1.0


func _init(up_cost : int, new_dmg : float, n_range : int):
	cost = up_cost
	new_damage = new_dmg
	new_range = n_range


func set_fire_rate(value : float):
	fire_rate = value
	return self
