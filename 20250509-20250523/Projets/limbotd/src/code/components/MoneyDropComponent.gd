extends Node
class_name MoneyDropComponent


export var amount : int = 5

func _ready():
	var __ = owner.get_node("LifeComponent").connect("dead", self, "drop")


func drop(_node)->void:
	if not PLAYER.is_alive():
		return
	PLAYER.money += amount
