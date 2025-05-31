extends ItemList


onready var original_position : Vector2 = rect_position
onready var hide_pos : Vector2 = rect_position - rect_size * Vector2(1, 0)


export var hidden_items : PoolIntArray = []



var selected_spot

var is_opened : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	var __ = PLAYER.connect("money_changed", self, "_on_player_money_changed")
	hide()
	fill_items()


# to be called by dialogic
func enable_item(index : String)->void:
	hidden_items.remove(int(index))
	fill_items()


func fill_items()->void:
	var available_bps : Array = [
		TowerBPFactory.basic_tower(),
		TowerBPFactory.missile_tower(),
		TowerBPFactory.laser_tower(),
		TowerBPFactory.fireworks_tower()
	]
	clear()
	var i : int = 0
	var n_items : int = 0
	for bp in available_bps:
		if not i in hidden_items:
			add_item("%d | %s" % [bp.cost, bp.tower_name], load("res://icon.png"))
			set_item_metadata(n_items, bp)
			set_item_tooltip_enabled(n_items, false)
			n_items += 1
		i += 1
	
	select(0)


func set_buyable()->void:
	for i in range(get_item_count()):
		var disable : bool = get_item_metadata(i).cost > PLAYER.money
		set_item_disabled(i, disable)


func appear()->void:
	show()
	set_buyable()
	
	var tween := get_tree().create_tween()
	
	var __ = tween.tween_property(
		self, "rect_position", original_position, 0.2
	).set_trans(Tween.TRANS_EXPO)
	tween.play()
	
	yield(tween, "finished")
	is_opened = true
	grab_focus()


func disappear()->void:
	selected_spot = null
	
	var tween := get_tree().create_tween()
	
	var __ = tween.tween_property(self, "rect_position", hide_pos, 0.2)
	tween.play()
	
	yield(tween, "finished")
	is_opened = false
	hide()


func buy_tower(tower_data : TowerBlueprint)->void:
	if selected_spot == null:
		push_error("Tried to buy a tower, but selected spot is null !")
		return
	selected_spot.spawn_tower(tower_data.scene_path, tower_data)



func _unhandled_input(event):
	if event is InputEventMouseButton and is_opened:
		if event.pressed and event.button_index != BUTTON_MIDDLE:
			disappear()
			return
	if Input.is_action_just_pressed("ui_cancel"):
		disappear()
		return


func _on_tower_spot_tower_requested(spot):
	if selected_spot != null or is_opened:
		return
	selected_spot = spot
	appear()


func _on_Shop_item_activated(index):
	if not is_opened:
		return
	
	var bp : TowerBlueprint = get_item_metadata(index)
	
	if PLAYER.money < bp.cost:
		print("not enough money !")
		return
	
	PLAYER.money -= bp.cost
	
	buy_tower(bp)
	disappear()


func _on_player_money_changed(_value)->void:
	if not visible:
		return
	set_buyable()
