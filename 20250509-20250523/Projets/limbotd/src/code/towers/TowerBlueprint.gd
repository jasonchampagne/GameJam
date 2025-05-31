extends Resource
class_name TowerBlueprint


export var tower_name : String
export var scene_path : String
export var cost : int
export var sell_value_scale : float = 0.7

export var upgrades : Array = []
export var fire_rate : float = 1.0



func _init(tname : String, path : String, tcost : int, ups : Array):
	tower_name = tname
	scene_path = path
	cost = tcost
	
	upgrades = ups


func set_sell_value_scale(value : float):
	sell_value_scale = value
	return self


func set_fire_rate(value : float):
	fire_rate = value
	return self
