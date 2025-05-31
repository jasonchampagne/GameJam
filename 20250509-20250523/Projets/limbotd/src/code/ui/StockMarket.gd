extends ItemList


const MONEY = 0
const LIFE = 1


export var market_perturbation_scale : float = 1
export var base_money_worth_in_life = [100, 5]
export var base_life_worth_in_money = [1, 300]

export(Curve) var life_value_scale : Curve

var money_worth_in_life : Array = [0, 0]
var life_worth_in_money : Array = [0, 0]


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	set_item_tooltip_enabled(MONEY, false)
	set_item_tooltip_enabled(LIFE, false)
	call_deferred("update_market")
	select(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func appear()->void:
	update_market()
	
	visible = true
	grab_focus()


func update_worths()->void:
	money_worth_in_life[0] = base_money_worth_in_life[0] * (life_value_scale.interpolate(
		(PLAYER.life / float(PLAYER.MAX_LIFE))
	))
	life_worth_in_money[0] = base_life_worth_in_money[0]
	
	life_worth_in_money[1] = float(base_life_worth_in_money[1]) * life_value_scale.interpolate(
		PLAYER.life / float(PLAYER.MAX_LIFE)
	)
	money_worth_in_life[1] = 1
	
#	money_worth_in_life[1] = 


func update_market()->void:
	update_worths()
#	unselect_all()
	set_item_text(MONEY, "%d Vie -> %d Âmes" % [money_worth_in_life[1], money_worth_in_life[0]])
	set_item_text(LIFE, "%d Âmes -> %d Vie" % [life_worth_in_money[1], life_worth_in_money[0]])
	set_item_disabled(LIFE, PLAYER.money < life_worth_in_money[1] or PLAYER.life >= PLAYER.MAX_LIFE)
	set_item_disabled(MONEY, PLAYER.life < money_worth_in_life[1])


func buy_life()->void:
	if PLAYER.money < life_worth_in_money[1]:
		print("not enough money to buy life")
		return
	if PLAYER.life >= PLAYER.MAX_LIFE:
		print("can't buy life. Already at max life")
		return
	PLAYER.life += life_worth_in_money[0]
	PLAYER.money -= life_worth_in_money[1]
	
	print("bought ", life_worth_in_money[0], " life")


func buy_money()->void:
	if PLAYER.life < money_worth_in_life[1]:
		print("not enough life to buy money")
		return
	PLAYER.money += money_worth_in_life[0]
	PLAYER.life -= money_worth_in_life[1]
	if not PLAYER.is_alive():
		print("player has suicided")
		hide()
	print("bought ", money_worth_in_life[0], " money")


func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		hide()
		return
	if event is InputEventMouse and event.is_pressed():
		hide()


func _on_StockMarket_item_activated(index):
	match index:
		LIFE:
			buy_life()
		MONEY:
			buy_money()
		_:
			return
	update_market()
