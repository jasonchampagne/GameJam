class_name MetaMOVE extends LinesCardUIData

var _multip_point: int = 1
var _multip_move: int = 1


func _get_multip_point() -> int:
	return _multip_point


func _set_multip_point(multip_point: int) -> void:
	self._multip_point = multip_point


func _get_multip_move() -> int:
	return _multip_move


func _set_multip_move(multip_move: int) -> void:
	self._multip_move = multip_move


func _init() -> void:
	type_card = Globals.TypeCard.MOVE


func amplify(amp: int, positive: bool = true) -> void:
	if positive:
		_multip_move = _multip_move * amp
	else:
		_multip_move = _multip_move / amp


func action(dir: String, local_maze: GridCaseMaze) -> ResultActionCard:
	var result: ResultActionCard = ResultActionCard.new()
	var current_position: Vector2i = local_maze.get_player_position()
	var case_maze: CaseMaze = local_maze.get_case_maze(current_position.x, current_position.y)
	for i in range(_get_multip_move()):
		result.moves.append(dir)
		current_position = current_position + Globals.INPUTS_I[dir]
		var loca_case_maze: CaseMaze = local_maze.get_case_maze(
			current_position.x, current_position.y
		)
		if (
			local_maze.on_outside(current_position.x, current_position.y)
			or (loca_case_maze.get_type() == Globals.TypeCase.CASEMUR)
		):
			#on the edge of maze we stop
			return null
		case_maze = local_maze.get_case_maze(current_position.x, current_position.y)
		result.point += _get_multip_point() * case_maze.get_point()
		result.target = current_position
	result.current_maze = local_maze
	return result


func reverse(current_dir: String, local_maze: GridCaseMaze) -> ResultActionCard:
	var result: ResultActionCard = ResultActionCard.new()
	var opposite_dir: String = Globals.OPPOSITE_DIR.get(current_dir)
	var current_position: Vector2i = local_maze.get_player_position()
	current_position = current_position + Globals.INPUTS_I[current_dir]
	var case_maze: CaseMaze = local_maze.get_case_maze(current_position.x, current_position.y)
	for i in range(_get_multip_move()):
		result.moves.append(opposite_dir)
		current_position = current_position + Globals.INPUTS_I[opposite_dir]
		case_maze = local_maze.get_case_maze(current_position.x, current_position.y)
		result.point -= _get_multip_point() * case_maze.get_point()
	return result
