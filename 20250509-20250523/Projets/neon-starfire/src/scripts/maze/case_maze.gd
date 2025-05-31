class_name CaseMaze extends Resource

var _position: Vector2i
var _point: int
var _type: Globals.TypeCase
var _type_details: Globals.TypeCaseDetails


func _init(
	position: Vector2i,
	point: int,
	type: Globals.TypeCase,
	type_details: Globals.TypeCaseDetails = Globals.TypeCaseDetails.CASELIBRE
) -> void:
	self._position = position
	self._point = point
	self._type = type
	# default _type_details
	self._type_details = type_details
	if type == Globals.TypeCase.CASEMUR:
		self._type_details = Globals.TypeCaseDetails.CASEMUR


func _to_string() -> String:
	var string_result: String = ""
	string_result += str(_type)
	return string_result


func set_point(point: int) -> void:
	self._point = point


func multiple_point(multi: int) -> void:
	self._point = self._point * multi


func divide_point(multi: int) -> void:
	@warning_ignore("integer_division")
	self._point = self._point / multi


func copy() -> CaseMaze:
	var new_case: CaseMaze = CaseMaze.new(
		self._position, self._point, self._type, self._type_details
	)
	return new_case


func get_point() -> int:
	return self._point


func get_position() -> Vector2i:
	return self._position


func get_type() -> Globals.TypeCase:
	return self._type


func set_type(type: Globals.TypeCase) -> void:
	self._type = type


func get_type_details() -> Globals.TypeCaseDetails:
	return self._type_details


func set_type_details(type_details: Globals.TypeCaseDetails) -> void:
	self._type_details = type_details
