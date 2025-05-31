# gdlint: disable=max-public-methods
class_name GridCaseMaze
extends Resource

enum TurnMazeDirection { LEFT, RIGHT, HORIZONTAL, VERTICAL }

var _grid_case: Array[Array]

var _h: int
var _w: int
var _global_h: int
var _global_w: int
var _end: Vector2i
var _player_position: Vector2i


func _init(initial_width: int, initial_height: int) -> void:
	self._grid_case = []
	self._h = initial_width
	self._w = initial_height
	self._global_h = (2 * self._h) + 1
	self._global_w = (2 * self._w) + 1
	for i in range(_global_h):
		_grid_case.append([])
		for j in range(_global_w):  # Ajouter un 1 à chaque colonne de cette ligne
			_grid_case[i].append(CaseMaze.new(Vector2i(i, j), 1, Globals.TypeCase.CASEMUR))
	self._end = Vector2i(get_weight() - 2, get_hight() - 2)


func _to_string() -> String:
	var string_result: String = ""
	for i in range(_global_h):
		string_result += "g[" + str(i) + "]=["
		for j in range(_global_w):  # Ajouter un 1 à chaque colonne de cette ligne
			string_result += str(_grid_case[i][j]) + ","
		string_result = string_result.left(string_result.length() - 1)
		string_result += "]\n"
	return string_result


func generate_start() -> CaseMaze:
	var should_break: bool = false
	var start: CaseMaze
	for i in range(0, self.get_weight()):
		for j in range(0, self.get_hight(), 2):
			if self.get_type_case(i, j) != Globals.TypeCase.CASEMUR:
				start = self.get_case_maze(i, 0)

				should_break = true
				break
		if should_break:
			break  # Casse la boucle externe
	# put the player on the start position
	set_type_case(start.get_position().x, start.get_position().y, Globals.TypeCase.CASELIBRE)
	return start


func get_type_case(position_x: int, position_y: int) -> Globals.TypeCase:
	var current_case: CaseMaze = _grid_case[position_x][position_y]
	return current_case.get_type()


func is_not_wall(position_x: int, position_y: int) -> bool:
	if position_x < 0 or position_x >= _global_w or position_y < 0 or position_y >= _global_h:
		return true
	var current_case: CaseMaze = _grid_case[position_x][position_y]
	return current_case.get_type() != Globals.TypeCase.CASEMUR


func set_type_case(position_x: int, position_y: int, type: Globals.TypeCase) -> void:
	var current_case: CaseMaze = _grid_case[position_x][position_y]
	current_case.set_type(type)


func set_case(position_x: int, position_y: int, new_case: CaseMaze) -> void:
	_grid_case[position_x][position_y] = new_case


func get_type_case_details(position_x: int, position_y: int) -> Globals.TypeCaseDetails:
	var current_case: CaseMaze = _grid_case[position_x][position_y]
	return current_case.get_type_details()


func set_type_case_details(position_x: int, position_y: int, type: Globals.TypeCaseDetails) -> void:
	var current_case: CaseMaze = _grid_case[position_x][position_y]
	current_case.set_type_details(type)


func on_edge(position_x: int, position_y: int) -> bool:
	if position_x == 0 or position_x == get_weight() - 1:  # Bord gauche ou droit
		return true
	if position_y == 0 or position_y == get_hight() - 1:  # Bord haut ou bas
		return true
	return false


func on_outside(position_x: int, position_y: int) -> bool:
	if position_x == 0 or position_x == get_weight():  # Bord gauche ou droit
		return true
	if position_y == 0 or position_y == get_hight():  # Bord haut ou bas
		return true
	return false


func get_point_case(position_x: int, position_y: int) -> int:
	var current_case: CaseMaze = _grid_case[position_x][position_y]
	return current_case.get_point()


func set_point_case(position_x: int, position_y: int, point: int) -> void:
	var current_case: CaseMaze = _grid_case[position_x][position_y]
	current_case.set_point(point)


func get_case_maze(position_x: int, position_y: int) -> CaseMaze:
	return _grid_case[position_x][position_y]


func add_case(position_x: int, position_y: int, type: Globals.TypeCase) -> void:
	# play the percent
	var point: int = 1
	var random_value: float = randf()
	if random_value < Globals.POURCENTAGE_CASEDOUBLE:
		point = 2
	self.add_case_with_point(position_x, position_y, point, type)


func add_case_with_point(
	position_x: int, position_y: int, local_point: int, type: Globals.TypeCase
) -> void:
	self.add_case_with_point_detail(position_x, position_y, local_point, type)


func add_case_with_point_detail(
	position_x: int,
	position_y: int,
	local_point: int,
	type: Globals.TypeCase,
	type_detail: Globals.TypeCaseDetails = Globals.TypeCaseDetails.CASELIBRE
) -> void:
	# play the percent
	var point: int = local_point
	_grid_case[position_x][position_y] = CaseMaze.new(
		Vector2i(position_x, position_y), point, type, type_detail
	)


func copy() -> GridCaseMaze:
	var new_grid: GridCaseMaze = GridCaseMaze.new(self._h, self._w)
	new_grid.set_end(self._end)
	new_grid._grid_case = self._grid_case.duplicate(true)
	return new_grid


func _turn_maze(direction: TurnMazeDirection) -> void:
	# local copie to current grid
	var old_grid: GridCaseMaze = self.copy()
	#self._init(old_grid._h,old_grid._w)
	var old_end: Vector2i = self._end
	var i_bis: int = old_grid.get_weight()
	for i in range(0, old_grid.get_weight()):
		i_bis -= 1
		var j_bis: int = old_grid.get_hight()
		for j in range(0, old_grid.get_hight()):
			j_bis -= 1
			var local_case: CaseMaze = old_grid.get_case_maze(i, j)
			var local_new_place: Vector2i
			if direction == TurnMazeDirection.RIGHT:
				local_new_place = Vector2i(j_bis, i)
			if direction == TurnMazeDirection.LEFT:
				local_new_place = Vector2i(j, i_bis)
			if direction == TurnMazeDirection.VERTICAL:
				local_new_place = Vector2i(i, j_bis)
			if direction == TurnMazeDirection.HORIZONTAL:
				local_new_place = Vector2i(i_bis, j)
			self.add_case_with_point_detail(
				local_new_place.x,
				local_new_place.y,
				local_case.get_point(),
				local_case.get_type(),
				local_case.get_type_details()
			)
			if local_case._position == old_end:
				self._end = local_new_place


func turn_maze_up_right() -> void:
	self._turn_maze(TurnMazeDirection.RIGHT)


func turn_maze_up_left() -> void:
	self._turn_maze(TurnMazeDirection.LEFT)


func flip_vertical_maze() -> void:
	self._turn_maze(TurnMazeDirection.VERTICAL)


func flip_horizontal_maze() -> void:
	self._turn_maze(TurnMazeDirection.HORIZONTAL)


func get_end() -> Vector2i:
	return _end


func set_end(end: Vector2i) -> void:
	self._end = end


func get_player_position() -> Vector2i:
	return _player_position


func get_case_maze_player() -> CaseMaze:
	return _grid_case[self._player_position.x][self._player_position.y]


func set_player_position(player_position: Vector2i) -> void:
	self._player_position = player_position


func get_weight() -> int:
	return _grid_case.size()


func get_hight() -> int:
	return _grid_case[0].size()
