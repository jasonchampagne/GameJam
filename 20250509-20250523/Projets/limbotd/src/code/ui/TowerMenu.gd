extends Control


export var offset : Vector2 = Vector2(50, -100)


onready var upgrade_button := $GridContainer/Upgrade
onready var sell_button := $GridContainer/Sell
onready var grid := $GridContainer

onready var initial_position : Vector2 = rect_position

var selected_spot

var is_opened : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	var __ = PLAYER.connect("money_changed", self, "_on_player_money_changed")
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_price(button : Button, prefix : String, price : int)->void:
	button.text = prefix + str(price)


func set_tower_info()->void:
	
	if selected_spot.tower.level >= selected_spot.tower.max_level:
		upgrade_button.text = "Niveau Max"
	elif not selected_spot.tower.can_upgrade():
		upgrade_button.text = "Impossible"
	else:
		set_price(upgrade_button, "Améliorer : ", get_upgrade().cost)
	
	set_price(sell_button, "Vendre : ", selected_spot.tower.get_sell_value())



func get_upgrade()->TowerUpgrade:
	var tower_blueprint : TowerBlueprint = selected_spot.tower.blueprint
	var tower_upgrade : TowerUpgrade = tower_blueprint.upgrades[selected_spot.tower.level]
	
	return tower_upgrade


func set_can_upgrade()->void:
	upgrade_button.disabled =  not selected_spot.tower.can_upgrade() or (
		PLAYER.money < get_upgrade().cost
	)


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed and visible:
			selected_spot.tower.set_is_show_range(false)
			selected_spot = null
			hide()


func _on_Upgrade_pressed():
	if not selected_spot.tower.can_upgrade():
		print("cannot upgrade this tower")
		return
	
	var tower_upgrade := get_upgrade()
	
	if PLAYER.money < tower_upgrade.cost:
		print("not enough money to upgrade")
		return
	
	PLAYER.money -= tower_upgrade.cost
	
	selected_spot.tower.upgrade(tower_upgrade)
	set_can_upgrade()
	set_tower_info()
#	hide()


func _on_Sell_pressed():
	selected_spot.sell_tower()
	selected_spot = null
	hide()


func _on_tower_spot_menu_requested(spot)->void:
	selected_spot = spot
	
	
	set_can_upgrade()
	
	set_tower_info()
	
	rect_position = initial_position + Vector2(0, grid.rect_size.y)
	
	show()
	var tween := get_tree().create_tween()
	var __ = tween.tween_property(self, "rect_position", initial_position, 0.2).set_trans(
		Tween.TRANS_BACK
	)
	tween.play()


func _on_player_money_changed(_value)->void:
	if not visible or selected_spot == null:
		return
	
	set_can_upgrade()
