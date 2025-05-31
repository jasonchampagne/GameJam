class_name AmpliX2 extends LinesCardUIData

const MULTIPLICATOR: int = 2
var multiplicator_courrant: int = MULTIPLICATOR
var targeted_card: LinesCardUIData


func _init() -> void:
	type_card = Globals.TypeCard.AMPLIFICATEUR


# gdlint: disable=unused-argument

@warning_ignore("unused_parameter")


func action(dir: String, local_maze: GridCaseMaze) -> ResultActionCard:
	var result: ResultActionCard = ResultActionCard.new()
	targeted_card.amplify(MULTIPLICATOR, true)
	return result


func amplify(amp: int, positive: bool = true) -> void:
	if positive:
		multiplicator_courrant = multiplicator_courrant * amp
	else:
		@warning_ignore("integer_division")
		multiplicator_courrant = multiplicator_courrant / amp


@warning_ignore("unused_parameter")


func reverse(dir: String, local_maze: GridCaseMaze) -> ResultActionCard:
	var result: ResultActionCard = ResultActionCard.new()
	self.unset_target_card()
	return result


func set_target_card(target: LinesCardUIData) -> void:
	self.targeted_card = target


func unset_target_card() -> void:
	if targeted_card != null:
		targeted_card.amplify(MULTIPLICATOR, false)
	self.targeted_card = null
