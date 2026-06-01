extends Node

# Character manager - handles character creation, equipment, stats

func create_default_character() -> Dictionary:
	return {
		"name": "Hero",
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
		"equipment": {
			"pickaxe": "",
			"fishing_rod": "",
			"weapon": "",
			"offhand": "",
			"headgear": "",
			"earring": "",
			"necklace": "",
			"ring": "",
			"bracelet": "",
			"upper_armor": "",
			"lower_armor": "",
			"gloves": "",
			"boots": ""
		},
		"skills": [],
		"collected_fish": []
	}

func equip_item(character: Dictionary, slot: String, item_id: String) -> Dictionary:
	var item = ItemDatabase.get_item(item_id)
	if item.is_empty():
		return character
	
	# Remove old equipment stats
	if character["equipment"][slot]:
		var old_item = ItemDatabase.get_item(character["equipment"][slot])
		if old_item.has("stats"):
			for stat in old_item["stats"]:
				if stat in character:
					character[stat] -= old_item["stats"][stat]
	
	# Apply new equipment stats
	if item.has("stats"):
		for stat in item["stats"]:
			if stat in character:
				character[stat] += item["stats"][stat]
	
	character["equipment"][slot] = item_id
	return character

func allocate_stat_point(character: Dictionary, stat: String, amount: int = 1) -> Dictionary:
	if character["stat_points"] < amount:
		return character
	
	match stat:
		"hp":
			character["max_hp"] += 5 * amount
			character["hp"] = character["max_hp"]
		"atk":
			character["atk"] += 2 * amount
		"def":
			character["def"] += 2 * amount
		"agi":
			character["agi"] += 1 * amount
	
	character["stat_points"] -= amount
	return character
