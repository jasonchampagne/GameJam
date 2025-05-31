class_name MetaMaze extends LinesCardUIData

var impacted_case: Array[Array] = []


func _init() -> void:
	type_card = Globals.TypeCard.MAZE


func _internal_update_case(
	local_maze: GridCaseMaze,
	i: int,
	j: int,
	type_case: Globals.TypeCase,
	type_case_detail: Globals.TypeCaseDetails
):
	var origine_case: CaseMaze = local_maze.get_case_maze(i, j)
	impacted_case.append([Vector2i(i, j), origine_case.copy()])
	local_maze.set_type_case(i, j, type_case)
	local_maze.set_type_case_details(i, j, type_case_detail)


# gdlint: disable=unused-argument

@warning_ignore("unused_parameter")


func reverse(dir: String, local_maze: GridCaseMaze) -> ResultActionCard:
	var result: ResultActionCard = ResultActionCard.new()
	for vect_struct in impacted_case:
		var vect = vect_struct[0]
		var origine_case: CaseMaze = vect_struct[1]
		local_maze.set_case(vect.x, vect.y, origine_case)
	impacted_case = []
	if self.get_sound() != "":
		result.sound = self.get_sound().replace(".", "_reverse.")
	result.point = 0
	return result
