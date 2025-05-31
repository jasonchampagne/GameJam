class_name StageSimple extends Control

signal level_won
signal level_lost

var level_state: LevelState
var core_engine: CoreEngine

var start: CaseMaze
var current_point_label: Array[Label] = []

@onready var player: PlayerSprite = %Player
@onready var tilemap: TileMapLayer = %TileMapLayer
@onready var audio_stream_sfx: AudioStreamPlayer = %AudioStreamSFX
@onready var grid_maze: GridCaseMaze = GridCaseMaze.new(
	Globals.current_maze_width, Globals.current_maze_height
)


func _on_lose_button_pressed() -> void:
	level_lost.emit()


func _on_win_button_pressed() -> void:
	level_won.emit()


func open_tutorials() -> void:
	level_state.tutorial_read = true


func _ready() -> void:
	level_state = GameState.get_level_state(scene_file_path)
	generate_maze()
	core_engine = CoreEngine.new(grid_maze)
	core_engine.update_player_move.connect(move_player.bind())
	core_engine.update_score.connect(Globals.core_player.update_score.bind())
	core_engine.update_score.connect(update_score_display.bind())
	core_engine.update_maze.connect(update_maze.bind())
	core_engine.init_start(start)
	Globals.core_player.add_move(start.get_position())
	if not level_state.tutorial_read:
		open_tutorials()

	%UICards.grid_maze = grid_maze
	%UICards.core_engine = core_engine


func update_score_display(score: int) -> void:
	%UICards.score.text = tr("Score") + " : " + str(Globals.core_player.score)


func update_maze(result_card: ResultActionCard) -> void:
	self._display_maze()
	var lib_effects: libEffects = libEffects.new()
	lib_effects.control(result_card, tilemap)
	if result_card.sound != "":
		#TODO bug audio not correctly set in child like stage_boss
		if audio_stream_sfx :
			audio_stream_sfx.stream = load(Globals.PATH_CARD_SOUND_EFFETS + result_card.sound)
			audio_stream_sfx.play()
	# refind solution
	#generate_solution()
	_write_traces()


func _on_tutorial_button_pressed() -> void:
	open_tutorials()


func move_player(moves: Array[String], forward: bool = false) -> void:
	#verify if the move is not outside the maze
	for dir in moves:
		var target_grid: Vector2i = Globals.core_player.get_last_move() + Globals.INPUTS_I[dir]
		await player.move(dir, forward)
		# For display reason we wait end player move
		if forward:
			_add_point_to_case(target_grid)
			libEffects.remove_effect_tile(tilemap, target_grid)
		grid_maze.set_player_position(target_grid)
		Globals.core_player.add_move(target_grid)
		if target_grid == grid_maze._end:
			level_won.emit()
	_write_traces()


func _write_traces() -> void:
	var dirs: Array[String] = core_engine.get_all_moves()
	var current_position: Vector2i = self.start.get_position()
	for current_move in dirs:
		_write_trace(current_position)
		current_position = current_position + Globals.INPUTS_I[current_move]


func _write_trace(last_position: Vector2i) -> void:
	# remove the label point
	_remove_point_to_case(last_position)
	#tilemap.set_cell(last_position, 0, case_to_set, transform_flags)
	#libEffects.pulse_tile(tilemap, last_position)


func _add_point_to_case(target: Vector2i) -> void:
	if target != start.get_position():
		var position_text: Vector2 = tilemap.map_to_local(target)
		var label: Label = libEffects.add_label(
			tilemap,
			position_text,
			str(grid_maze.get_point_case(target.x, target.y)),
			Globals.TILE_SIZE
		)
		current_point_label.append(label)


func _remove_point_to_case(target: Vector2i) -> void:
	if target != start.get_position():
		var position_text: Vector2 = tilemap.map_to_local(target)
		var label: Label = libEffects.remove_label(tilemap, position_text)
		var idx: int = current_point_label.find(label)
		if idx != -1:
			current_point_label.remove_at(idx)


func _remove_all_point_labels() -> void:
	while current_point_label.size() > 0:
		tilemap.remove_child(current_point_label.pop_back())


func generate_maze() -> void:
	var engine = GrowingTree.new(grid_maze)
	#seed(3297551004)
	engine.generate_maze(3297551004, 0.1)
	#engine.generate_maze(randi(),0.1)
	#engine.generate_maze(0,Globals.POURCENTAGE_BACKTRACK)
	self.start = grid_maze.generate_start()
	_display_maze()
	var local_pos = tilemap.map_to_local(self.start.get_position())
	player.global_position = tilemap.to_global(local_pos)
	grid_maze.set_player_position(self.start.get_position())


func _display_maze() -> void:
	self._remove_all_point_labels()
	for row in range(grid_maze.get_weight()):
		for col in range(grid_maze.get_hight()):
			var target: Vector2i = Vector2i(row, col)
			if grid_maze.get_type_case(row, col) == Globals.TypeCase.CASEMUR:
				var tile_index = 0
				if grid_maze.is_not_wall(row - 1, col):  # Pas de mur au-dessus
					tile_index += 1  # Haut
				if grid_maze.is_not_wall(row + 1, col):  # Pas de mur en dessous
					tile_index += 2  # Bas
				if grid_maze.is_not_wall(row, col - 1):  # Pas de mur à gauche
					tile_index += 4  # Gauche
				if grid_maze.is_not_wall(row, col + 1):  # Pas de mur à droite
					tile_index += 8  # Droit
				var cell = Globals.TILE_MAPPING[tile_index]
				tilemap.set_cell(target, 1, cell, 0)
			else:
				tilemap.set_cell(
					target, 0, Globals.DISPLAY_CASE[Globals.TypeCaseDetails.CASELIBRE], 0
				)
				_add_point_to_case(target)
			libEffects.remove_effect_tile(tilemap, target)
	# display end
	tilemap.set_cell(start.get_position(), 0, Globals.CELL_CASEEND, 0)
	tilemap.set_cell(grid_maze.get_end(), 0, Globals.CELL_CASEEND, 0)
