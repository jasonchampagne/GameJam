extends LinesCardUIData

const MULTIPLICATOR: int = 1
var current_multiplicator: int = MULTIPLICATOR

var score: int


func _init() -> void:
	type_card = Globals.TypeCard.SCORE


func set_score(current_score: int) -> void:
	self.score = current_score


# gdlint: disable=unused-argument

@warning_ignore("unused_parameter")


func action(
	dir: String, local_maze: GridCaseMaze, local_player: CorePlayer = null
) -> ResultActionCard:
	score = Globals.core_player.score
	var result: ResultActionCard = ResultActionCard.new()
	for multi in range(current_multiplicator):
		result.point += score
	return result


@warning_ignore("unused_parameter")


func reverse(dir: String, local_maze: GridCaseMaze) -> ResultActionCard:
	var result: ResultActionCard = ResultActionCard.new()
	for multi in range(current_multiplicator):
		result.point -= score
	return result
