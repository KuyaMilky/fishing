extends Node

# Item database - loads all items and fish from JSON

var items: Dictionary = {}
var fish_species: Array = []
var rarity_colors: Dictionary = {
	"common": Color.GRAY,
	"uncommon": Color.GREEN,
	"rare": Color.BLUE,
	"epic": Color.MAGENTA,
	"legendary": Color.ORANGE,
	"mythic": Color(1.0, 0.2, 1.0)  # Pink/Red
}

func _ready():
	_load_items()
	_load_fish_species()

func _load_items():
	if ResourceLoader.exists("res://data/items.json"):
		var file = FileAccess.open("res://data/items.json", FileAccess.READ)
		if file:
			var json_str = file.get_as_text()
			items = JSON.parse_string(json_str) if json_str else {}
			print("[ItemDB] Loaded %d items" % items.size())

func _load_fish_species():
	if ResourceLoader.exists("res://data/fish_species.json"):
		var file = FileAccess.open("res://data/fish_species.json", FileAccess.READ)
		if file:
			var json_str = file.get_as_text()
			fish_species = JSON.parse_string(json_str) if json_str else []
			print("[ItemDB] Loaded %d fish" % fish_species.size())

func get_item(item_id: String) -> Dictionary:
	return items.get(item_id, {})

func get_rarity_color(rarity: String) -> Color:
	return rarity_colors.get(rarity, Color.WHITE)
