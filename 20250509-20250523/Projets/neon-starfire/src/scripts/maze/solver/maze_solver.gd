class_name MazeSolver extends Resource

var _start: Vector2i
var _end: Vector2i
var _grid: GridCaseMaze

@warning_ignore("unused_private_class_variable")
var _solutions: Array[Array] = []

@warning_ignore("unused_private_class_variable")
var _solutions_points: Array[int] = []


func _init(start: Vector2i, grid: GridCaseMaze):
	self._start = start
	self._end = grid.get_end()
	self._grid = grid


func calculate_point_solution(solution: Array) -> int:
	var sum_point: int = 0
	for case: Vector2i in solution:
		sum_point += _grid.get_point_case(case.x, case.y)
	return sum_point


static func print_array(grid: Array[Array], to_export: bool = false) -> void:
	if !to_export:
		for col in range(grid[0].size()):
			var col_text = ""
			for row in grid:
				col_text += "#" if row[col] else " "
			print_debug(col_text)
	else:
		for row in grid:
			var current_line = str("[", row[0])
			for col in range(1, row.size()):
				current_line += str(",", row[col])
			current_line = str(current_line, "]")
			print_debug(current_line)


func _prune_solution(solution: Array[Vector2i]) -> Array[Vector2i]:
	var found = true
	var attempt = 0
	var max_attempt = solution.size()
	var first_i
	var last_i
	while found and solution.size() > 2 and attempt < max_attempt:
		found = false
		attempt += 1

		for i in range(solution.size() - 1):
			var first = solution[i]
			var sub_solution = solution.slice(i + 1, solution.size() - (i + 1))
			if first in sub_solution:
				first_i = i
				last_i = sub_solution.find(first) + i + 1
				found = true
				break

		if found:
			solution = solution.slice(0, first_i) + solution.slice(last_i, solution.size() - last_i)

	# Retirer les points d'entrée et de sortie
	if solution.size() > 1:
		if solution[0] == self._start:
			solution = solution.slice(1, solution.size() - 1)
		if solution[solution.size() - 1] == self._end:
			solution = solution.slice(0, solution.size() - 1)
	return solution


func prune_solutions(solutions: Array[Array]) -> Array[Array]:
	var cleaned_solutions: Array[Array] = []
	for s in solutions:
		cleaned_solutions.append(_prune_solution(s))
	return cleaned_solutions


func _find_unblocked_neighbors(position: Vector2i) -> Array[Vector2i]:
	var arr: Array[Vector2i] = []

	for dir in Globals.DIRECTIONS_I:
		var neighbor = position + dir

		# Vérifier les limites de la grille
		if (
			neighbor.x >= 0
			and neighbor.x < _grid.get_weight()
			and neighbor.y >= Globals.TypeCase.CASELIBRE
			and neighbor.y < _grid.get_hight()
		):
			# Vérifier si la cellule est un passage libre (0) et n'a pas été visitée
			if _grid.get_type_case(neighbor.x, neighbor.y) == Globals.TypeCase.CASELIBRE:
				arr.append(neighbor)

	#arr.shuffle()
	#print_debug("Neighbors found:", arr, " for ", posi)
	#print_debug(_grid)
	return arr


func _push_edge(posi: Vector2i) -> Vector2i:
	var row: int = posi.x
	var col: int = posi.y

	var grid_rows = _grid.get_weight()  # Nombre de lignes
	var grid_cols = _grid.get_hight()  # Nombre de colonnes (assumant que la grille est rectangulaire)

	# Fixe les conditions
	if row == 0:
		return Vector2i(1, col)
	if row == grid_rows - 1:
		return Vector2i(row - 1, col)
	if col == 0:
		return Vector2i(row, 1)
	if col == grid_cols - 1:
		return Vector2i(row, col - 1)
	return posi


func _on_edge(posi: Vector2i) -> bool:
	var row: int = posi.x
	var col: int = posi.y

	if row == 0 or row == (_grid.get_weight() - 1):
		return true
	if col == 0 or col == (_grid.get_hight() - 1):
		return true
	return false


func _midpoint(a: Vector2i, b: Vector2i) -> Vector2i:
	@warning_ignore("integer_division")
	return Vector2i((a.x + b.x) / 2, (a.y + b.y) / 2)


func _within_one(posi: Vector2i, desire: Vector2i) -> bool:
	if not posi or not desire:
		return false
	if posi.x == desire.x:
		if abs(posi.y - desire.y) < 2:
			return true
	elif posi.y == desire.y:
		if abs(posi.x - desire.x) < 2:
			return true
	return false
