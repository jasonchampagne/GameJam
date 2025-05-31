extends CanvasLayer

### INFO : Godot does not advise to separate UI in different scenes because it would be harder 
###          to change the UI if needed


onready var money_label := $HBoxContainer/Money
onready var life_label := $HBoxContainer/Life
onready var market := $StockMarket


# Called when the node enters the scene tree for the first time.
func _ready():
	var __ = PLAYER.connect("money_changed", self, "_on_player_money_changed")
	__ = PLAYER.connect("life_changed", self, "_on_player_life_changed")
	set_money_text(PLAYER.money)
	set_life_text(PLAYER.life)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_money_text(value : int)->void:
	money_label.text = "Âmes : %d" % [value]


func set_life_text(value : int)->void:
	life_label.text = "Vies : %d" % [value]


func _on_player_money_changed(value : int)->void:
	set_money_text(value)


func _on_player_life_changed(value : int)->void:
	set_life_text(value)


func _on_Market_pressed():
	market.appear()
