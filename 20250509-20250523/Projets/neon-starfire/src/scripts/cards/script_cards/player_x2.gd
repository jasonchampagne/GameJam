extends LinesCardUIData

const MULTIPLICATOR: int = 1
const LIFE_COUNT: int = 2

var current_multiplicator: int = MULTIPLICATOR
var current_life_count: int = LIFE_COUNT


func _init() -> void:
	type_card = Globals.TypeCard.PLAYER


# gdlint: disable=unused-argument

@warning_ignore("unused_parameter")


func action(dir: String, local_maze: GridCaseMaze) -> ResultActionCard:
	var result: ResultActionCard = ResultActionCard.new()
	current_life_count -= 1
	#if life_count >0:

	return result


@warning_ignore("unused_parameter")


func reverse(dir: String, local_maze: GridCaseMaze) -> ResultActionCard:
	var result: ResultActionCard = ResultActionCard.new()
	current_life_count += 1
	return result
