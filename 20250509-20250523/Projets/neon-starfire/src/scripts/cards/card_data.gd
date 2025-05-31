class_name LinesCardUIData extends CardUIData

@export var type: String
@export var cost: int
@export var power: int
@export var description: String
@export var sound: String = ""
@export var texture_path: String = ""
@export var backface_texture_path: String = ""
@export var resource_script_path: String = ""

#TODO how to load directly this value from json
var type_card: Globals.TypeCard


# gdlint: disable=unused-argument
func get_description() -> String:
	return description


func get_type_card() -> Globals.TypeCard:
	return type_card


func get_power() -> int:
	return power


func get_cost() -> int:
	return cost


func get_sound() -> String:
	return sound


@warning_ignore("unused_parameter")


func action(dir: String, local_maze: GridCaseMaze) -> ResultActionCard:
	return null


@warning_ignore("unused_parameter")


func reverse(dir: String, local_maze: GridCaseMaze) -> ResultActionCard:
	return null


@warning_ignore("unused_parameter")


func amplify(amp: int, positive: bool = true) -> void:
	pass
