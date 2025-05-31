class_name EnchantMaze extends MetaMaze

const POURCENTAGE_CASE: float = 0.2
const MULTIPLICATOR: int = 2


func _init() -> void:
	type_card = Globals.TypeCard.MAZE


# gdlint: disable=unused-argument

@warning_ignore("unused_parameter")


func action(dir: String, local_maze: GridCaseMaze) -> ResultActionCard:
	var result: ResultActionCard = ResultActionCard.new()
	# scan de maze en change pourcentage_tir of wall to libre
	# on parcours pas les pourtour d'ou le range(1,..-1)
	for i in range(1, local_maze.get_weight() - 1):
		for j in range(1, local_maze.get_hight() - 1):
			if local_maze.get_type_case(i, j) == Globals.TypeCase.CASELIBRE:
				var random_value: float = randf()
				if random_value < POURCENTAGE_CASE:
					self._internal_update_case(
						local_maze,
						i,
						j,
						Globals.TypeCase.CASELIBRE,
						Globals.TypeCaseDetails.CASEEXPLOSED
					)
					local_maze.get_case_maze(i, j).multiple_point(MULTIPLICATOR)
	result.point = 0
	return result
