class_name ShortestPath extends MazeSolver


# BFS pour trouver le plus court chemin dans une grille
func bfs_maze_solver(grid: GridCaseMaze, start: Vector2i, goal: Vector2i) -> Array:
	# Queue pour le BFS (chaque élément est un tuple de position et chemin jusqu'ici)
	var queue: Array = []
	queue.append([start, []])

	# Liste pour garder une trace des cellules visitées
	var visited = []
	for i in range(grid.get_weight()):
		visited.append([])
		for j in range(grid.get_hight()):
			visited[i].append(false)

	# Marquer la case de départ comme visitée
	visited[start.x][start.y] = true

	while queue.size() > 0:
		var current = queue.pop_front()
		var position = current[0]
		var path = current[1]

		# Si nous sommes arrivés à la destination
		if position == goal:
			return path + [goal]  # Retourner le chemin trouvé

		# Explorer les voisins
		for dir in Globals.DIRECTIONS_I:
			var neighbor = position + dir

			# Vérifier les limites de la grille
			if (
				neighbor.x >= 0
				and neighbor.x < grid.get_weight()
				and neighbor.y >= Globals.TypeCase.CASELIBRE
				and neighbor.y < grid.get_hight()
			):
				# Vérifier si la cellule est un passage libre (0) et n'a pas été visitée
				if (
					grid.get_type_case(neighbor.x, neighbor.y) == Globals.TypeCase.CASELIBRE
					and not visited[neighbor.x][neighbor.y]
				):
					visited[neighbor.x][neighbor.y] = true
					# Ajouter le voisin à la queue avec le chemin mis à jour
					queue.append([neighbor, path + [position]])

	# Si aucun chemin n'est trouvé
	return []


func generate_solution() -> Array[Array]:
	#return shortest_path(_end)
	# TODO optimization, for the moment, we calculate the result here,
	#but it must be process during the solution generation

	#if solutions.size() == 0:
	#solutions = self.prune_solutions(solutions)
	_solutions.append(self.bfs_maze_solver(_grid, _start, _end))
	return _solutions


func shortest_path(end: Vector2i) -> Array[Array]:
	# Initialiser la queue BFS
	# La queue contient des chemins, chaque chemin est un Array de positions (Vector2i)
	var queue: Array[Array] = [[_start]]
	var solutions: Array[Array] = []  # Pour stocker les 5 chemins les plus courts

	while queue.size() > 0 and solutions.size() < 5:
		var path = queue.pop_front()  # On récupère le chemin actuel
		var position = path[-1]  # Dernière position dans le chemin actuel

		# Si nous avons atteint l'objectif, ajouter le chemin aux solutions
		if position == end:
			solutions.append(path)
			continue

		# Explorer les cases adjacentes
		for direction in Globals.DIRECTIONS_I:
			var next_pos = position + direction
			# Vérifier si la position suivante est dans les limites du labyrinthe
			# et accessible (0 pour les passages)
			if (
				next_pos.x >= 0
				and next_pos.x < _grid.get_weight()
				and next_pos.y >= 0
				and next_pos.y < _grid.get_hight()
			):
				if (
					_grid.get_type_case(next_pos.x, next_pos.y) == Globals.TypeCase.CASELIBRE
					and next_pos not in path
				):
					# Créer un nouveau chemin en ajoutant la position suivante
					var new_path = path.duplicate()
					new_path.append(next_pos)
					queue.append(new_path)  # Ajouter le nouveau chemin à la queue
	print_debug("number of solutions : ", solutions.size())
	return solutions


func _local_generate_solution() -> Array[Array]:
	# determine if edge or body entrances
	#self._start_edge = _on_edge(_start)
	#self._end_edge = _on_edge(_start)

	# a first move has to be made
	var start: Vector2i = _start
	#if self._start_edge:
	#start = _push_edge(_start)

	# find the starting positions
	var start_posis: Array[Vector2i] = _find_unblocked_neighbors(start)
	# assert len(start_posis) > 0, "Input maze is invalid."

	# 1) create a solution for each starting position
	var solutions: Array = []
	#print_array(_grid)
	for start_posi in start_posis:
		#if self._start_edge:
		solutions.append([start, _midpoint(start, start_posi), start_posi])
		#else:
		#solutions.append([_midpoint(start, start_posi), start_posi])

	# 2) loop through each solution, and find the neighbors of the last element
	var num_unfinished: int = solutions.size()
	while num_unfinished > 0:
		for s in range(solutions.size()):
			if solutions[s][-1] in solutions[s].slice(0, -1):
				# stop all solutions that have done a full loop
				solutions[s].append(null)
			elif solutions[s][-1] != null and _end == solutions[s][-1]:
				# stop all solutions that have reached the end
				return _clean_up([solutions[s]])

			elif solutions[s][-1] != null:
				# continue with all un-stopped solutions
				if solutions[s].size() > 1:
					# check to see if you've gone past the endpoint
					if _midpoint(solutions[s][-1], solutions[s][-2]) == _end:
						return _clean_up([solutions[s].slice(0, -1)])

				# find all the neighbors of the last cell in the solution
				var ns: Array[Vector2i] = _find_unblocked_neighbors(solutions[s][-1])
				var filtered_ns: Array[Vector2i] = []
				for n in ns:
					if n not in solutions[s]:
						filtered_ns.append(n)
				ns = filtered_ns
				# ns = [n for n in ns if n not in solutions[s]]

				if ns.size() == 0:
					# there are no valid neighbors
					solutions[s].append(null)
				elif ns.size() == 1:
					# there is only one valid neighbor
					solutions[s].append(_midpoint(ns[0], solutions[s][-1]))
					solutions[s].append(ns[0])
				else:
					# there are 2 or 3 valid neigbors
					for j in range(1, ns.size()):
						print_debug(" s = ", s, " j = ", j, " num_unfinished  ", num_unfinished)
						var nxt: Array = [_midpoint(ns[j], solutions[s][-1]), ns[j]]
						# TODO to check
						solutions.append(solutions[s] + nxt)
						# solutions.append(nxt)
					solutions[s].append(_midpoint(ns[0], solutions[s][-1]))
					solutions[s].append(ns[0])

		# 3) a solution reaches the end or a dead end when we mark it by appending a None.
		#num_unfinished = sum(
		#map(lambda sol: 0 if sol[-1] is None else 1, solutions)
		#)

		var new_num_unfinished = 0
		for sol in solutions:
			if sol[-1] != null:
				new_num_unfinished += 1
		num_unfinished = new_num_unfinished

	return _clean_up(solutions)


func _clean_up(solutions: Array) -> Array[Array]:
	# 1) remove incomplete solutions
	var new_solutions: Array[Array] = []
	for sol in solutions:
		var new_sol: Array
		# remove inside-maze-case end cells
		if sol[-1] == null:
			new_sol = sol.slice(0, -1)
		if sol.size() > 2 and _within_one(sol[-2], _end):
			new_sol = sol.slice(0, -1)

		if new_sol:
			if new_sol[-1] == _end:
				new_sol = new_sol.slice(0, -1)
			new_solutions.append(new_sol)

	# 2) remove duplicate solutions
	solutions = _remove_duplicate_sols(solutions)

	# order the solutions by length (short to long)
	# order the solutions by length (short to long)
	solutions.sort_custom(_compare_length)
	return solutions


func _compare_length(a: Array, b: Array) -> bool:
	if a.size() > b.size():
		return true
	return false


func _remove_duplicate_sols(sols: Array) -> Array[Array]:
	var unique_sols: Array[Array] = []  # Tableau pour stocker les solutions uniques
	var seen: Array[Vector2i]  # Tableau pour stocker les solutions uniques sous forme de chaînes
	var unique_solution: Array[Vector2i]
	# Boucle sur chaque sous-tableau
	for sol in sols:
		seen = []
		unique_solution = []
		for elmt_sol in sol:
			if not seen.has(elmt_sol):
				seen.append(elmt_sol)
				unique_solution.append(elmt_sol)  # Ajouter le tableau original dans la liste unique
		unique_sols.append(unique_solution)
	return unique_sols
	#return [list(s) for s in set(map(tuple, sols))]
