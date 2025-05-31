extends Node

const MAX_LIFE = 20

signal money_changed(value)
signal life_changed(value)
signal dead()



var money : int = 200   setget set_money
var life : int = MAX_LIFE setget set_life



func is_alive()->bool:
	return life > 0


#te be called by dialogic
func add_money(amount : String)->void:
	set_money(money + int(amount))


func add_life(amount : String)->void:
	set_life(life + int(amount))


func set_money(value : int)->void:
	var previous : int = money
	money = value
	
	if previous != money:
		emit_signal("money_changed", money)


func set_life(value : int)->void:
	var previous : int = life
	life = int(clamp(value, 0.0, MAX_LIFE))
	
	if previous != life:
		emit_signal("life_changed", life)
		if life <= 0:
			emit_signal("dead")


func set_stats(new_money)->void:
	set_money(new_money + DEBUG.player_money)
	set_life(MAX_LIFE + DEBUG.player_life)
