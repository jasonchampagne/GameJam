extends LinesCardUIData

const ORIGIN_IMPACT_SIZE: int = 3
var impact_size: float = ORIGIN_IMPACT_SIZE

var score: int
var impacted_case: Array[Array] = []


func _internal_update_case(
	local_maze: GridCaseMaze,
	x: int,
	y: int,
	type_case: Globals.TypeCase,
	type_case_detail: Globals.TypeCaseDetails
):
	var origine_case: CaseMaze = local_maze.get_case_maze(x, y)
	impacted_case.append([Vector2i(x, y), origine_case.copy()])
	local_maze.set_type_case(x, y, type_case)
	local_maze.set_type_case_details(x, y, type_case_detail)


func _init() -> void:
	type_card = Globals.TypeCard.SCORE


func set_score(current_score: int) -> void:
	self.score = current_score


# gdlint: disable=unused-argument

@warning_ignore("unused_parameter")


func action(dir: String, local_maze: GridCaseMaze) -> ResultActionCard:
	var result: ResultActionCard = ResultActionCard.new()
	var player_position: Vector2i = local_maze.get_player_position()
	for y in range(player_position.y - impact_size, player_position.y + impact_size + 1):
		# Calculer la largeur du losange à chaque ligne
		var row_width: int = impact_size - abs(player_position.y - y)
		for x in range(player_position.x - row_width, player_position.x + row_width + 1):
			if x >= 0 and x < local_maze.get_weight() and y >= 0 and y < local_maze.get_hight():
				if !local_maze.on_edge(x, y):
					var origine_case: CaseMaze = local_maze.get_case_maze(x, y)
					if origine_case.get_type() == Globals.TypeCase.CASELIBRE:
						result.point += local_maze.get_point_case(x, y)
						self._internal_update_case(
							local_maze,
							x,
							y,
							Globals.TypeCase.CASELIBRE,
							Globals.TypeCaseDetails.CASEEXPLOSED
					)
					local_maze.get_case_maze(x, y).set_point(0)
	return result


@warning_ignore("unused_parameter")


func reverse(dir: String, local_maze: GridCaseMaze) -> ResultActionCard:
	var result: ResultActionCard = ResultActionCard.new()
	for vect_struct in impacted_case:
		var vect = vect_struct[0]
		var origine_case: CaseMaze = vect_struct[1]
		local_maze.set_case(vect.x, vect.y, origine_case)
		result.point -= origine_case.get_point()
	impacted_case = []
	return result
