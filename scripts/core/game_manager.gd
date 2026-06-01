extends Node

var current_character: Dictionary = {}
var item_db: Dictionary = {}
var fish_db: Array = []
var fish_bonuses: Dictionary = {}

func _ready():
	# Load data
	_load_game_data()
	
	# Connect UI buttons
	var start_btn = $UI/StartScreen/VBoxContainer/StartButton
	if start_btn:
		start_btn.pressed.connect(_on_start_pressed)
	
	var mine_btn = $World/HUD/ButtonContainer/MineButton
	if mine_btn:
		mine_btn.pressed.connect(_on_mine_pressed)
	
	var fish_btn = $World/HUD/ButtonContainer/FishButton
	if fish_btn:
		fish_btn.pressed.connect(_on_fish_pressed)
	
	var inv_btn = $World/HUD/ButtonContainer/InventoryButton
	if inv_btn:
		inv_btn.pressed.connect(_on_inventory_pressed)
	
	var lvl_btn = $World/HUD/ButtonContainer/LevelUpButton
	if lvl_btn:
		lvl_btn.pressed.connect(_on_levelup_pressed)
	
	var skl_btn = $World/HUD/ButtonContainer/SkillsButton
	if skl_btn:
		skl_btn.pressed.connect(_on_skills_pressed)

func _load_game_data():
	# Load items
	if ResourceLoader.exists("res://data/items.json"):
		var file = FileAccess.open("res://data/items.json", FileAccess.READ)
		if file:
			var json_str = file.get_as_text()
			item_db = JSON.parse_string(json_str) if json_str else {}
	
	# Load fish species
	if ResourceLoader.exists("res://data/fish_species.json"):
		var file = FileAccess.open("res://data/fish_species.json", FileAccess.READ)
		if file:
			var json_str = file.get_as_text()
			fish_db = JSON.parse_string(json_str) if json_str else []
	
	# Load fish bonuses
	if ResourceLoader.exists("res://data/fish_bonuses.json"):
		var file = FileAccess.open("res://data/fish_bonuses.json", FileAccess.READ)
		if file:
			var json_str = file.get_as_text()
			fish_bonuses = JSON.parse_string(json_str) if json_str else {}
	
	print("Data loaded: %d items, %d fish species" % [item_db.size(), fish_db.size()])

func _on_start_pressed():
	var name_input = $UI/StartScreen/VBoxContainer/NameInput
	var character_name = name_input.text.strip_edges()
	
	if character_name.is_empty():
		print("Please enter a character name")
		return
	
	# Load or create character
	current_character = _load_or_create_character(character_name)
	
	# Start game
	$UI/StartScreen.visible = false
	$World.visible = true
	_refresh_ui()

func _load_or_create_character(name: String) -> Dictionary:
	var save_path = "user://characters/%s.json" % name
	
	# Try to load existing character
	if ResourceLoader.exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file:
			var json_str = file.get_as_text()
			var data = JSON.parse_string(json_str)
			if data:
				print("Loaded character: %s" % name)
				return data
	
	# Create new character
	var new_char = {
		"name": name,
		"level": 1,
		"exp": 0,
		"exp_to_level": 100,
		"hp": 100,
		"max_hp": 100,
		"atk": 10,
		"def": 5,
		"agi": 8,
		"stat_points": 0,
		"gold": 0,
		"silver": 0,
		"copper": 0,
		"inventory": [],
		"equipment": ["", "", "", "", "", "", "", "", "", ""],
		"collected_fish": [],
		"skills": [],
		"created_at": Time.get_ticks_msec()
	}
	
	_save_character(new_char)
	print("Created new character: %s" % name)
	return new_char

func _save_character(character: Dictionary):
	var dir = DirAccess.open("user://")
	if not dir.dir_exists("characters"):
		dir.make_dir("characters")
	
	var save_path = "user://characters/%s.json" % character["name"]
	var json_str = JSON.stringify(character)
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(json_str)
		print("Saved character: %s" % save_path)

func _refresh_ui():
	if not current_character:
		return
	
	var stats_panel = $World/HUD/StatsPanel/VBoxContainer
	stats_panel.get_node("NameLabel").text = "Character: %s (Level %d)" % [current_character["name"], current_character["level"]]
	stats_panel.get_node("LevelLabel").text = "Level: %d | EXP: %d/%d" % [current_character["level"], current_character["exp"], current_character["exp_to_level"]]
	stats_panel.get_node("HealthLabel").text = "HP: %d/%d" % [current_character["hp"], current_character["max_hp"]]
	stats_panel.get_node("StatsLabel").text = "ATK: %d | DEF: %d | AGI: %d" % [current_character["atk"], current_character["def"], current_character["agi"]]
	stats_panel.get_node("CurrencyLabel").text = "Gold: %d | Silver: %d | Copper: %d" % [current_character["gold"], current_character["silver"], current_character["copper"]]

func _on_mine_pressed():
	print("=== MINING ===")
	var gold_gain = randi_range(10, 30)
	var silver_gain = randi_range(5, 15)
	var copper_gain = randi_range(20, 50)
	
	current_character["gold"] += gold_gain
	current_character["silver"] += silver_gain
	current_character["copper"] += copper_gain
	
	# Random ore drop
	var ore_types = ["copper_ore", "iron_ore", "gold_ore", "mithril_ore"]
	var chances = [0.6, 0.25, 0.1, 0.05]
	var rand = randf()
	var cumulative = 0.0
	var ore_dropped = ""
	
	for i in range(ore_types.size()):
		cumulative += chances[i]
		if rand < cumulative:
			ore_dropped = ore_types[i]
			break
	
	if ore_dropped:
		current_character["inventory"].append({"id": ore_dropped, "quantity": 1})
		print("Mined: %s" % ore_dropped)
	
	print("Gained: Gold x%d, Silver x%d, Copper x%d" % [gold_gain, silver_gain, copper_gain])
	current_character["exp"] += 10
	_check_level_up()
	_save_character(current_character)
	_refresh_ui()

func _on_fish_pressed():
	print("=== FISHING ===")
	if fish_db.is_empty():
		print("No fish database loaded!")
		return
	
	# Random fish catch
	if randf() < 0.7:  # 70% catch rate
		var rarity = _roll_rarity()
		var candidates = []
		
		for fish in fish_db:
			if fish.get("rarity") == rarity:
				candidates.append(fish)
		
		if candidates.size() > 0:
			var caught = candidates[randi() % candidates.size()]
			var fish_id = caught["id"]
			
			# Add to inventory
			var found = false
			for inv_item in current_character["inventory"]:
				if inv_item["id"] == fish_id:
					inv_item["quantity"] += 1
					found = true
					break
			
			if not found:
				current_character["inventory"].append({"id": fish_id, "quantity": 1})
			
			# Add to collection
			if not fish_id in current_character["collected_fish"]:
				current_character["collected_fish"].append(fish_id)
				print("NEW CATCH! %s (%s)" % [caught["name"], rarity])
				_check_fish_bonus()
			else:
				print("Caught: %s (%s)" % [caught["name"], rarity])
			
			current_character["gold"] += caught.get("value", 10)
			current_character["exp"] += 5
	else:
		print("No catch this time...")
	
	_check_level_up()
	_save_character(current_character)
	_refresh_ui()

func _roll_rarity() -> String:
	var weights = {
		"common": 0.50,
		"uncommon": 0.30,
		"rare": 0.12,
		"epic": 0.05,
		"legendary": 0.02,
		"mythic": 0.01
	}
	
	var roll = randf()
	var cumulative = 0.0
	
	for rarity in ["common", "uncommon", "rare", "epic", "legendary", "mythic"]:
		cumulative += weights.get(rarity, 0.0)
		if roll <= cumulative:
			return rarity
	
	return "common"

func _check_level_up():
	while current_character["exp"] >= current_character["exp_to_level"]:
		current_character["exp"] -= current_character["exp_to_level"]
		current_character["level"] += 1
		current_character["exp_to_level"] = int(current_character["exp_to_level"] * 1.1)
		current_character["stat_points"] += 5
		current_character["max_hp"] += 10
		current_character["hp"] = current_character["max_hp"]
		print("LEVEL UP! Now level %d" % current_character["level"])

func _check_fish_bonus():
	var collected_count = current_character["collected_fish"].size()
	for milestone in [5, 10, 15, 20, 30, 40, 50]:
		if collected_count == milestone and fish_bonuses.has(str(milestone)):
			var bonus = fish_bonuses[str(milestone)]
			print("*** COLLECTION BONUS: %s ***" % bonus["name"])
			if bonus.has("stats"):
				for stat in bonus["stats"]:
					if stat == "hp":
						current_character["max_hp"] += bonus["stats"][stat]
						current_character["hp"] = current_character["max_hp"]
					elif stat == "atk":
						current_character["atk"] += bonus["stats"][stat]
					elif stat == "def":
						current_character["def"] += bonus["stats"][stat]
					elif stat == "agi":
						current_character["agi"] += bonus["stats"][stat]

func _on_inventory_pressed():
	print("=== INVENTORY ===")
	if current_character["inventory"].is_empty():
		print("Inventory is empty!")
		return
	
	print("Items in inventory:")
	for item in current_character["inventory"]:
		var item_data = item_db.get(item["id"], {})
		var name = item_data.get("name", item["id"])
		print("  - %s x%d (Value: %d gold)" % [name, item["quantity"], item_data.get("value", 0)])

func _on_levelup_pressed():
	print("=== LEVEL UP SCREEN ===")
	print("Available Points: %d" % current_character["stat_points"])
	print("Current Stats:")
	print("  HP: %d (Max: %d)" % [current_character["hp"], current_character["max_hp"]])
	print("  ATK: %d" % current_character["atk"])
	print("  DEF: %d" % current_character["def"])
	print("  AGI: %d" % current_character["agi"])
	
	# Auto-allocate some points for demo
	if current_character["stat_points"] > 0:
		current_character["atk"] += 1
		current_character["stat_points"] -= 1
		print("Auto-allocated 1 point to ATK")
		_save_character(current_character)
		_refresh_ui()

func _on_skills_pressed():
	print("=== SKILLS ===")
	var skill_types = ["flame_skill", "frost_skill", "lightning_skill"]
	print("Available Skills:")
	for skill_id in skill_types:
		var skill = item_db.get(skill_id, {})
		print("  - %s (Element: %s)" % [skill.get("name", skill_id), skill.get("element", "unknown")])

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if not current_character.is_empty():
			_save_character(current_character)
		get_tree().quit()
