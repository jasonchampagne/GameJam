extends Node
class_name TowerBPFactory


static func basic_tower()->TowerBlueprint:
	return TowerBlueprint.new(
		"Âmort !", 
		"res://scenes/towers/Tower.tscn", 
		100,
		[
			TowerUpgrade.new(110, 11, 215),
			TowerUpgrade.new(120, 12.25, 230),
			TowerUpgrade.new(130, 15, 245),
			TowerUpgrade.new(140, 20, 260).set_fire_rate(0.4)
		]
	)


static func missile_tower()->TowerBlueprint:
	return TowerBlueprint.new(
		"Lance-missiles", 
		"res://scenes/towers/attacking/MissileTower.tscn", 
		150,
		[
			TowerUpgrade.new(175, 65, 250),
			TowerUpgrade.new(225, 100, 250),
			TowerUpgrade.new(350, 75, 250).set_fire_rate(2.0),
			TowerUpgrade.new(600, 75, 300).set_fire_rate(2.0)
		]
	)


static func laser_tower()->TowerBlueprint:
	return TowerBlueprint.new(
		"Laser de la Mort", 
		"res://scenes/towers/attacking/LaserTower.tscn", 
		250,
		[
			TowerUpgrade.new(350, 0.2, 225),
			TowerUpgrade.new(500, 0.35, 225),
			TowerUpgrade.new(750, 0.75, 250),
			TowerUpgrade.new(1000, 1.0, 350)
		]
	)


static func fireworks_tower()->TowerBlueprint:
	return TowerBlueprint.new(
		"Feux d'artifices",
		"res://scenes/towers/attacking/Fireworks.tscn",
		150,
		[
			TowerUpgrade.new(250, 10, 1000),
			TowerUpgrade.new(300, 15, 2000)
		]
	)
