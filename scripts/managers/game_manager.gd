extends Node

# Main game manager - handles game state and auto-play

var current_character: Dictionary = {}
var is_mining: bool = false
var is_fishing: bool = false
var mining_timer: float = 0.0
var fishing_timer: float = 0.0
var auto_play_speed: float = 1.0  # Can be adjusted for difficulty

func _ready():
	set_process(true)
	current_character = CharacterManager.create_default_character()
	GameManager.save_character(current_character)

func _process(delta):
	if is_mining:
		mining_timer += delta * auto_play_speed
		if mining_timer >= 3.0:  # Mine every 3 seconds
			_perform_mine()
			mining_timer = 0.0
	
	if is_fishing:
		fishing_timer += delta * auto_play_speed
		if fishing_timer >= 5.0:  # Fish every 5 seconds
			_perform_fish()
			fishing_timer = 0.0

func toggle_mining():
	is_mining = !is_mining
	print("Mining: %s" % ("ON" if is_mining else "OFF"))

func toggle_fishing():
	is_fishing = !is_fishing
	print("Fishing: %s" % ("ON" if is_fishing else "OFF"))

func _perform_mine():
	var ore = _roll_ore()
	if ore:
		current_character["inventory"].append({"id": ore["id"], "quantity": 1})
		current_character["gold"] += ore.get("value", 1)
		print("⛏️ Mined: %s" % ore["name"])

func _perform_fish():
	var fish = _roll_fish()
	if fish:
		var found = false
		for inv_item in current_character["inventory"]:
			if inv_item["id"] == fish["id"]:
				inv_item["quantity"] += 1
				found = true
				break
		
		if not found:
			current_character["inventory"].append({"id": fish["id"], "quantity": 1})
		
		if not fish["id"] in current_character["collected_fish"]:
			current_character["collected_fish"].append(fish["id"])
			print("🎣 NEW CATCH: %s (%s)" % [fish["name"], fish["rarity"]])
		else:
			print("🎣 Caught: %s" % fish["name"])

func _roll_ore() -> Dictionary:
	var ores = ItemDatabase.items.values().filter(func(x): return x.get("type") == "ore")
	if ores.size() > 0:
		return ores[randi() % ores.size()]
	return {}

func _roll_fish() -> Dictionary:
	var fish_list = ItemDatabase.fish_species
	var rarity = _roll_rarity()
	var candidates = fish_list.filter(func(x): return x.get("rarity") == rarity)
	if candidates.size() > 0:
		return candidates[randi() % candidates.size()]
	return {}

func _roll_rarity() -> String:
	var weights = {
		"common": 0.60,
		"uncommon": 0.25,
		"rare": 0.10,
		"epic": 0.04,
		"legendary": 0.0005,
		"mythic": 0.00005
	}
	var roll = randf()
	var cumulative = 0.0
	for rarity in ["common", "uncommon", "rare", "epic", "legendary", "mythic"]:
		cumulative += weights.get(rarity, 0.0)
		if roll <= cumulative:
			return rarity
	return "common"

func save_character(player: Dictionary):
	var save_path = "user://characters/%s.json" % player["name"]
	var dir = DirAccess.open("user://")
	if not dir.dir_exists("characters"):
		dir.make_dir("characters")
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(player))
		print("Character saved: %s" % save_path)
