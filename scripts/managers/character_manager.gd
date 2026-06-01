extends Node

# Character manager for equipment and stats

func apply_equipment_stats(player: Dictionary, equipment_id: String, slot: String) -> Dictionary:
	var gear = ItemDatabase.get_gear(equipment_id)
	if gear.is_empty():
		return player
	
	# Remove old equipment stats
	if player["equipment"][slot]:
		var old_gear = ItemDatabase.get_gear(player["equipment"][slot])
		if not old_gear.is_empty() and old_gear.has("stats"):
			for stat in old_gear["stats"]:
				if stat in player:
					player[stat] -= old_gear["stats"][stat]
	
	# Apply new equipment stats
	if gear.has("stats"):
		for stat in gear["stats"]:
			if stat in player:
				player[stat] += gear["stats"][stat]
	
	player["equipment"][slot] = equipment_id
	return player

func remove_equipment(player: Dictionary, slot: String) -> Dictionary:
	if player["equipment"][slot]:
		var old_gear = ItemDatabase.get_gear(player["equipment"][slot])
		if not old_gear.is_empty() and old_gear.has("stats"):
			for stat in old_gear["stats"]:
				if stat in player:
					player[stat] -= old_gear["stats"][stat]
	
	player["equipment"][slot] = ""
	return player

func add_exp(player: Dictionary, amount: int) -> Dictionary:
	player["exp"] += amount
	while player["exp"] >= player["exp_to_level"]:
		player["exp"] -= player["exp_to_level"]
		level_up(player)
	return player

func level_up(player: Dictionary) -> Dictionary:
	player["level"] += 1
	player["exp_to_level"] = int(player["exp_to_level"] * 1.1)
	player["stat_points"] += 5
	player["max_hp"] += 10
	player["hp"] = player["max_hp"]
	print("%s leveled up to %d!" % [player["name"], player["level"]])
	return player

func allocate_stat_point(player: Dictionary, stat: String, amount: int) -> Dictionary:
	if player["stat_points"] < amount:
		return player
	
	if stat in player:
		if stat == "hp" or stat == "max_hp":
			player["max_hp"] += amount * 5
			player["hp"] = player["max_hp"]
	else:
		player[stat] += amount
	
	player["stat_points"] -= amount
	return player

func add_fish_to_collection(player: Dictionary, fish_id: String) -> Dictionary:
	if not fish_id in player["collected_fish"]:
		player["collected_fish"].append(fish_id)
		var bonus = _get_fish_bonus(player["collected_fish"].size())
		if bonus:
			player = _apply_bonus(player, bonus)
			print("Fish bonus unlocked: %s" % bonus["name"])
	return player

func _get_fish_bonus(collected_count: int) -> Dictionary:
	var bonuses = {
		1: {"name": "First Catch", "stats": {"agi": 1}},
		2: {"name": "Novice Fisher", "stats": {"hp": 1}},
		5: {"name": "Skilled Angler", "stats": {"def": 1}},
		10: {"name": "Master Fisher", "stats": {"atk": 2, "hp": 5}},
		20: {"name": "Legend of the Sea", "stats": {"atk": 3, "def": 2, "agi": 2}},
		50: {"name": "Mythical Fisher", "stats": {"atk": 5, "def": 5, "agi": 5, "max_hp": 20}}
	}
	return bonuses.get(collected_count, {})

func _apply_bonus(player: Dictionary, bonus: Dictionary) -> Dictionary:
	if bonus.has("stats"):
		for stat in bonus["stats"]:
			if stat == "max_hp":
				player["max_hp"] += bonus["stats"][stat]
				player["hp"] = player["max_hp"]
		elif stat in player:
			player[stat] += bonus["stats"][stat]
	return player
