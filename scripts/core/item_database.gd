class_name ItemDatabase

static var items: Dictionary = {}
static var fish_species: Array = []
static var fish_bonuses: Dictionary = {}

func _ready():
	load_data()

static func load_data():
	# Load items from JSON
	var items_file = FileAccess.open("res://data/items.json", FileAccess.READ)
	if items_file:
		var json = JSON.parse_string(items_file.get_as_text())
		if json:
			items = json
	
	# Load fish species
	var fish_file = FileAccess.open("res://data/fish_species.json", FileAccess.READ)
	if fish_file:
		var json = JSON.parse_string(fish_file.get_as_text())
		if json:
			fish_species = json
	
	# Load fish bonuses
	var bonuses_file = FileAccess.open("res://data/fish_bonuses.json", FileAccess.READ)
	if bonuses_file:
		var json = JSON.parse_string(bonuses_file.get_as_text())
		if json:
			fish_bonuses = json

static func get_item(item_id: String) -> Dictionary:
	return items.get(item_id, {})

static func get_fish_species(index: int) -> Dictionary:
	if index >= 0 and index < fish_species.size():
		return fish_species[index]
	return {}

static func get_fish_count() -> int:
	return fish_species.size()

static func get_fish_bonus(collected_count: int) -> Dictionary:
	return fish_bonuses.get(str(collected_count), {})

static func get_rarity_color(rarity: String) -> Color:
	var colors = {
		"common": Color.WHITE,
		"uncommon": Color.GREEN,
		"rare": Color.BLUE,
		"epic": Color.MAGENTA,
		"legendary": Color.ORANGE,
		"mythic": Color.YELLOW
	}
	return colors.get(rarity, Color.WHITE)
