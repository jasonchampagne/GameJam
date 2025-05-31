class_name MazeGenerator extends Resource

const OFFSETS: Array[Vector2i] = [Vector2i.DOWN, Vector2i.UP, Vector2i.RIGHT, Vector2i.LEFT]
var _grid: GridCaseMaze


func _init(grid: GridCaseMaze) -> void:
	self._grid = grid


func _find_neighbors(current_cel: Vector2i, is_wall: bool = false) -> Array[Vector2i]:
	var av: Array[Vector2i] = []
	var r: int = current_cel.x
	var c: int = current_cel.y
	if r > 1 and bool(_grid.get_type_case(r - 2, c) == Globals.TypeCase.CASEMUR) == is_wall:
		av.append(Vector2i(r - 2, c))
	if (
		r < _grid._global_h - 2
		and bool(_grid.get_type_case(r + 2, c) == Globals.TypeCase.CASEMUR) == is_wall
	):
		av.append(Vector2i(r + 2, c))
	if c > 1 and bool(_grid.get_type_case(r, c - 2) == Globals.TypeCase.CASEMUR) == is_wall:
		av.append(Vector2i(r, c - 2))
	if (
		c < _grid._global_w - 2
		and bool(_grid.get_type_case(r, c + 2) == Globals.TypeCase.CASEMUR) == is_wall
	):
		av.append(Vector2i(r, c + 2))
		av.shuffle()
	return av


func _contains_pair(arr: Vector2i, pair: Vector2i):
	#for element in arr:
	if arr.x == pair.x and arr.y == pair.y:
		return true
	return false
