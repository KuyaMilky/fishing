extends Node3D

# Fishing system for 3D environment

var caught_fish: Array = []
var is_fishing: bool = false

func fish() -> Dictionary:
	is_fishing = true
	
	if ItemDatabase.fish_species.size() == 0:
		return {}
	
	if randf() < 0.75:  # 75% catch rate
		var rarity = _roll_rarity()
		var candidates = []
		
		for fish in ItemDatabase.fish_species:
			if fish.get("rarity") == rarity:
				candidates.append(fish)
		
		if candidates.size() > 0:
			var caught = candidates[randi() % candidates.size()]
			return caught
	
	return {}

func _roll_rarity() -> String:
	var weights = {
		"common": 0.50,
		"uncommon": 0.30,
		"rare": 0.12,
		"epic": 0.05,
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
