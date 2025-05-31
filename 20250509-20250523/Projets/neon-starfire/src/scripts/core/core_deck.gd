class_name CoreDeck extends Resource

var current_cards_collection: Array[LinesCardUIData] = []
var current_cards_collection_repart: Dictionary = {}
var current_database_cards: Array = []


func _init(card_database_path: String) -> void:
	current_database_cards = _load_json_cards_from_path(card_database_path)
	_create_collection()


func get_card_database() -> Array:
	return current_database_cards


func _create_collection() -> void:
	for type_card in Globals.TypeCard.values():
		current_cards_collection_repart[type_card] = []
	for json_data in current_database_cards:
		var card_data: LinesCardUIData = ResourceLoader.load(json_data.resource_script_path).new()
		for key in json_data.keys():
			card_data[key] = json_data[key]
		current_cards_collection.append(card_data)
		current_cards_collection_repart[card_data.type_card].append(card_data)


func create_meta_deck_repartition() -> Dictionary:
	var key_repart: Dictionary = {}
	for type_card in Globals.TypeCard.values():
		match type_card:
			Globals.TypeCard.MOVE:
				key_repart[type_card] = 0.6
			Globals.TypeCard.AMPLIFICATEUR:
				key_repart[type_card] = 1.0
			Globals.TypeCard.MAZE:
				key_repart[type_card] = 0.95
			Globals.TypeCard.SCORE:
				key_repart[type_card] = 1.0
				#Globals.TypeCard.PLAYER:
				#key_repart[type_card]=0.0
	return key_repart


func create_meta_shop_repartition() -> Dictionary:
	var key_repart: Dictionary = {}
	for type_card in Globals.TypeCard.values():
		match type_card:
			Globals.TypeCard.MOVE:
				key_repart[type_card] = 0.2
			Globals.TypeCard.AMPLIFICATEUR:
				key_repart[type_card] = 0.7
			Globals.TypeCard.MAZE:
				key_repart[type_card] = 0.9
			Globals.TypeCard.SCORE:
				key_repart[type_card] = 1.0
				#Globals.TypeCard.PLAYER:
				#key_repart[type_card]=0.0
	return key_repart


func random_type_of_card(is_shop: bool = false) -> Globals.TypeCard:
	# TODO to optimize with singleton for key_repart
	var key_repart: Dictionary = create_meta_deck_repartition()
	if is_shop:
		key_repart = create_meta_shop_repartition()
	var random_value: float = randf()
	for type_card in key_repart.keys():
		if random_value < key_repart[type_card]:
			return type_card
	return Globals.TypeCard.MOVE


func create_deck(deck_size: int = Globals.DECK_SIZE) -> Array[LinesCardUIData]:
	var cards_data_deck: Array[LinesCardUIData] = []
	for i in range(deck_size):
		var card_type: Globals.TypeCard = random_type_of_card()
		var card_data: LinesCardUIData = current_cards_collection_repart[card_type].pick_random()
		cards_data_deck.append(card_data)
	return cards_data_deck


func create_fake_deck(deck_size: int = Globals.DECK_SIZE) -> Array[LinesCardUIData]:
	var cards_data_deck: Array[LinesCardUIData] = []
	for i in range(deck_size):
		var card_type = Globals.TypeCard.MAZE
		var card_data: LinesCardUIData = current_cards_collection_repart[card_type][i % 2]
		cards_data_deck.append(card_data)
	return cards_data_deck


static func get_deck_nice_name(current_cards_data_deck: Array[LinesCardUIData]) -> Array:
	return (
		current_cards_data_deck.map(func(data: LinesCardUIData): return data.nice_name)
		as Array[String]
	)


func generate_collection_shop(shop_size: int = Globals.SHOP_SIZE) -> Array[String]:
	var cards_collection_name: Array[String] = []
	for i in range(shop_size):
		var card_type = random_type_of_card(true)
		var card_data: LinesCardUIData = current_cards_collection_repart[card_type].pick_random()
		cards_collection_name.append(card_data.nice_name)
	return cards_collection_name


func _load_json_cards_from_path(path: String) -> Array:
	var found = []
	if path:
		var json_as_text = FileAccess.get_file_as_string(path)
		var json_as_dict = JSON.parse_string(json_as_text)
		if json_as_dict:
			for c in json_as_dict:
				found.push_back(c)
	return found
