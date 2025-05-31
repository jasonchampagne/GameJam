class_name TurnMaze extends LinesCardUIData


func _init() -> void:
	type_card = Globals.TypeCard.MAZE


# gdlint: disable=unused-argument

@warning_ignore("unused_parameter")


func action(dir: String, local_maze: GridCaseMaze) -> ResultActionCard:
	var result: ResultActionCard = ResultActionCard.new()
	local_maze.turn_maze_up_right()
	result.point = 0
	return result


@warning_ignore("unused_parameter")


func reverse(dir: String, local_maze: GridCaseMaze) -> ResultActionCard:
	var result: ResultActionCard = ResultActionCard.new()
	local_maze.turn_maze_up_left()
	result.point = 0
	return result
