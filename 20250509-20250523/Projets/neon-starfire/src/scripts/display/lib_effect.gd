class_name libEffects extends Resource

const EFFECT_PREFIX_TILE: String = "effect_"

static var _dynamic_font: FontFile = load("res://assets/fonts/AtariClassic-gry3.ttf")


func control(result_card: ResultActionCard, tilemap: TileMapLayer) -> void:
	if result_card.graphic_effect != "":
		self.call(result_card.graphic_effect, result_card, tilemap)


static func _generate_name_tile_effect(position: Vector2) -> String:
	var name: String = EFFECT_PREFIX_TILE + str(position.x) + "_" + str(position.y)
	return name.replace(".", "_")


static func _generate_tile_effect(position: Vector2, global_pos: Vector2) -> ColorRect:
	var rect: ColorRect = ColorRect.new()
	rect.name = _generate_name_tile_effect(position)
	@warning_ignore("integer_division")
	rect.position = (
		global_pos
		- Vector2(
			Globals.TILE_SIZE / 2,
			Globals.TILE_SIZE / 2,
		)
	)
	rect.size = Vector2(Globals.TILE_SIZE, Globals.TILE_SIZE)
	return rect


func gatling(result_card: ResultActionCard, tilemap: TileMapLayer) -> void:
	var grid_maze: GridCaseMaze = result_card.current_maze
	for row in range(grid_maze.get_weight()):
		for col in range(grid_maze.get_hight()):
			var target: Vector2i = Vector2i(row, col)
			if grid_maze.get_type_case_details(row, col) == Globals.TypeCaseDetails.CASEGATLINGED:
				#pulse_tile(tilemap, target)
				#explode_tile(tilemap, target)
				print_debug("gatlinged")


static func glow_light(target: Node) -> void:
	var shader_material = ShaderMaterial.new()
	shader_material.shader = preload("res://assets/effects/shaders/glow.gdshader")
	var color_rect: ColorRect = ColorRect.new()
	color_rect.size = target.size
	color_rect.set_color(Color.PURPLE)
	color_rect.anchor_left = 0
	color_rect.anchor_top = 0
	color_rect.anchor_right = 1
	color_rect.anchor_bottom = 1
	color_rect.material = shader_material
	target.add_child(color_rect)


static func lightning(target: Node) -> void:
	var shader_material = ShaderMaterial.new()
	shader_material.shader = preload("res://assets/effects/shaders/lightning.gdshader")
	shader_material.set_shader_parameter("base_color", Color("#A100FF"))
	var rect: ColorRect = ColorRect.new()
	rect.name = _generate_name_tile_effect(target.position)
	rect.material = shader_material
	target.add_child(rect)


static func pulse_light(target: Node) -> void:
	var shader_material = ShaderMaterial.new()
	shader_material.shader = preload("res://assets/effects/shaders/neon_shader_material.gdshader")
	shader_material.set_shader_parameter("mode", 0)
	shader_material.set_shader_parameter("pulse_speed", 0.5)
	shader_material.set_shader_parameter("full_pulse_cycle", "False")
	shader_material.set_shader_parameter("shine_color", Color("#A100FF"))
	target.material = shader_material


static func pulse_tile(tilemap: TileMapLayer, position: Vector2i) -> void:
	var parent_tilemap: Node = tilemap.get_parent()
	var local_pos: Vector2 = tilemap.map_to_local(position)
	var global_pos: Vector2 = tilemap.to_global(local_pos)
	var rect: ColorRect = _generate_tile_effect(position, global_pos)
	rect.color = Color(1, 0, 0)
	pulse_light(rect)
	parent_tilemap.add_child(rect)


static func explode_tile(tilemap: TileMapLayer, position: Vector2i) -> void:
	var parent_tilemap: Node = tilemap.get_parent()
	var local_pos: Vector2 = tilemap.map_to_local(position)
	var global_pos: Vector2 = tilemap.to_global(local_pos)
	var rect: ColorRect = _generate_tile_effect(position, global_pos)
	var shader_material = ShaderMaterial.new()
	parent_tilemap.add_child(rect)
	shader_material.shader = preload("res://assets/effects/shaders/pixel_explosion.gdshader")
	# var noise = NoiseTexture.new()
	# noise.noise = OpenSimplexNoise.new()
	# noise.noise.seed = randi(

	rect.material = shader_material
	parent_tilemap.add_child(rect)


static func remove_effect_tile(tilemap: TileMapLayer, position: Vector2i) -> void:
	var parent_tilemap: Node = tilemap.get_parent()
	var node_name = _generate_name_tile_effect(position)
	var effect_node = parent_tilemap.get_node_or_null(node_name)
	if effect_node:
		parent_tilemap.remove_child(effect_node)
		effect_node.queue_free()


static func create_border(target: Node, color: Color, border_size: int = 5) -> void:
	var width = target.size.x
	var height = target.size.y
	var starting_position: Vector2 = Vector2.ZERO
	var line_2d: Line2D = Line2D.new()
	line_2d.position = target.position
	line_2d.clear_points()
	line_2d.default_color = color
	line_2d.width = border_size
	line_2d.begin_cap_mode = Line2D.LineCapMode.LINE_CAP_ROUND
	line_2d.end_cap_mode = Line2D.LineCapMode.LINE_CAP_ROUND
	line_2d.add_point(starting_position)
	line_2d.add_point(starting_position + Vector2(width, 1))
	line_2d.add_point(starting_position + Vector2(width, height))
	line_2d.add_point(starting_position + Vector2(0, height))
	line_2d.add_point(starting_position + Vector2(0, height))
	line_2d.add_point(starting_position - Vector2(0, 0))
	target.add_child(line_2d)


static func create_border_on_rect(target: Rect2, color: Color, border_size: int = 5) -> Line2D:
	var width = target.size.x
	var height = target.size.y
	var starting_position: Vector2 = Vector2.ZERO
	var line_2d: Line2D = Line2D.new()
	line_2d.position = target.position
	line_2d.clear_points()
	line_2d.default_color = color
	line_2d.width = border_size
	line_2d.add_point(starting_position)
	line_2d.add_point(starting_position + Vector2(width, 1))
	line_2d.add_point(starting_position + Vector2(width, height))
	line_2d.add_point(starting_position + Vector2(0, height))
	return line_2d


static func _add_rounded_border(label: Label):
	var style = StyleBoxFlat.new()
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.bg_color = Color.BLACK
	style.border_color = Color("FF2EEC")
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	label.add_theme_stylebox_override("normal", style)


static func add_label(
	target: Node,
	position_text: Vector2,
	content: String,
	font_size: int = 5,
	color: Color = Color.DEEP_PINK
) -> Label:
	var string_node_path: String = (
		str(target.get_path()) + "/" + str(position_text.x) + str(position_text.y)
	)
	var old_label: Label = target.get_node_or_null(NodePath(string_node_path))
	if old_label != null:
		remove_label(target, position_text)
	var label: Label = Label.new()
	label.add_theme_font_override("font", _dynamic_font)
	label.add_theme_color_override("font_color", color)
	label.add_theme_font_size_override("font_size", font_size)
	label.name = str(position_text.x, position_text.y)
	label.text = content
	@warning_ignore("integer_division")
	label.position = position_text - Vector2(Globals.TILE_SIZE / 2, Globals.TILE_SIZE / 2)
	target.add_child(label)
	return label


static func remove_label(target: Node, position_text: Vector2) -> Label:
	var string_node_path: String = (
		str(target.get_path()) + "/" + str(position_text.x) + str(position_text.y)
	)
	string_node_path = string_node_path.replace(".", "_")
	var label: Label = target.get_node_or_null(NodePath(string_node_path))
	if label != null:
		target.remove_child(label)
	return label
