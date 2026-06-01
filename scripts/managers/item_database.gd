extends Node

# Item and gear database

var items: Dictionary = {}
var gears: Dictionary = {}
var skills: Dictionary = {}
var fish_species: Array = []

func _ready():
	_load_all_data()

func _load_all_data():
	_load_items()
	_load_gears()
	_load_skills()
	_load_fish_species()

func _load_items():
	if ResourceLoader.exists("res://data/items.json"):
		var file = FileAccess.open("res://data/items.json", FileAccess.READ)
		if file:
			var json_str = file.get_as_text()
			items = JSON.parse_string(json_str) if json_str else {}
			print("Loaded %d items" % items.size())

func _load_gears():
	if ResourceLoader.exists("res://data/gear_data.json"):
		var file = FileAccess.open("res://data/gear_data.json", FileAccess.READ)
		if file:
			var json_str = file.get_as_text()
			gears = JSON.parse_string(json_str) if json_str else {}
			print("Loaded %d gears" % gears.size())

func _load_skills():
	if ResourceLoader.exists("res://data/skills.json"):
		var file = FileAccess.open("res://data/skills.json", FileAccess.READ)
		if file:
			var json_str = file.get_as_text()
			skills = JSON.parse_string(json_str) if json_str else {}
			print("Loaded %d skills" % skills.size())

func _load_fish_species():
	if ResourceLoader.exists("res://data/fish_species.json"):
		var file = FileAccess.open("res://data/fish_species.json", FileAccess.READ)
		if file:
			var json_str = file.get_as_text()
			fish_species = JSON.parse_string(json_str) if json_str else []
			print("Loaded %d fish species" % fish_species.size())

func get_item(item_id: String) -> Dictionary:
	return items.get(item_id, {})

func get_gear(gear_id: String) -> Dictionary:
	return gears.get(gear_id, {})

func get_skill(skill_id: String) -> Dictionary:
	return skills.get(skill_id, {})

func get_fish(index: int) -> Dictionary:
	if index >= 0 and index < fish_species.size():
		return fish_species[index]
	return {}

func get_all_fish() -> Array:
	return fish_species

func get_rarity_color(rarity: String) -> Color:
	var colors = {
		"common": Color.WHITE,
		"uncommon": Color.GREEN,
		"rare": Color.BLUE,
		"epic": Color.MAGENTA,
		"legendary": Color.ORANGE,
		"mythic": Color.YELLOW
	}
	return colors.get(rarity, Color.WHITE)

func should_drop(rarity: String) -> bool:
	var drop_rates = {
		"common": 0.50,
		"uncommon": 0.25,
		"rare": 0.15,
		"epic": 0.04,
		"legendary": 0.0005,
		"mythic": 0.00005
	}
	var rate = drop_rates.get(rarity, 0.0)
	return randf() < rate
