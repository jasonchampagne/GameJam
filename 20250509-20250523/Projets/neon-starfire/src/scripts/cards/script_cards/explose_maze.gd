class_name ExploseMaze extends MetaMaze

const ORIGIN_IMPACT_SIZE: int = 3
var impact_size: float = ORIGIN_IMPACT_SIZE
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
					self._internal_update_case(
						local_maze,
						x,
						y,
						Globals.TypeCase.CASELIBRE,
						Globals.TypeCaseDetails.CASEEXPLOSED
					)
	result.point = 0
	return result


func reverse(dir: String, local_maze: GridCaseMaze) -> ResultActionCard:
	impact_size = ORIGIN_IMPACT_SIZE
	return super.reverse(dir, local_maze)


func amplify(amp: int, positive: bool = true) -> void:
	if positive:
		impact_size = impact_size * amp
	else:
		impact_size = impact_size / amp
