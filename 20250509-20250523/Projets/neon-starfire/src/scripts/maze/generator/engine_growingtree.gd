class_name GrowingTree extends MazeGenerator


func generate_maze(internal_seed: int = 0, backtrack_chance: float = 1.0) -> Array[Array]:
	randomize()
	# to fix randomize, put 0 in seed to randomize
	if internal_seed == 0:
		internal_seed = randi()
	seed(internal_seed)
	print_debug("seed : ", internal_seed)

	@warning_ignore("integer_division")
	var current_row: int = 1 + 2 * randi_range(0, (_grid._global_h - 1) / 2)
	@warning_ignore("integer_division")
	var current_col: int = 1 + 2 * randi_range(0, (_grid._global_w - 1) / 2)

	while current_row >= _grid.get_weight() or current_col >= _grid.get_hight():
		@warning_ignore("integer_division")
		current_row = 1 + 2 * randi_range(0, (_grid._global_h - 1) / 2)
		@warning_ignore("integer_division")
		current_col = 1 + 2 * randi_range(0, (_grid._global_w - 1) / 2)

	_grid.add_case(current_row, current_col, Globals.TypeCase.CASELIBRE)

	var active: Array = [Vector2i(current_row, current_col)]
	# continue until you have no more neighbors to move to
	while active.size() > 0:
		if randf() < backtrack_chance:
			current_row = active[-1].x
			current_col = active[-1].y
		else:
			var random_pos = active[randi_range(0, active.size() - 1)]
			current_row = random_pos.x
			current_col = random_pos.y

		# find a visited neighbor
		var next_neighbors = _find_neighbors(Vector2i(current_row, current_col), true)
		if next_neighbors.size() == 0:
			active = active.filter(func(a): return a != Vector2i(current_row, current_col))
			continue

		var random_neighbor = next_neighbors[randi_range(0, next_neighbors.size() - 1)]
		var nn_row = random_neighbor.x
		var nn_col = random_neighbor.y
		active.append(Vector2i(nn_row, nn_col))

		_grid.add_case(nn_row, nn_col, Globals.TypeCase.CASELIBRE)
		_grid.add_case(
			(current_row + nn_row) / 2, (current_col + nn_col) / 2, Globals.TypeCase.CASELIBRE
		)
	return []
