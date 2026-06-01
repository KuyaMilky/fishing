extends Node3D

# Mining system for 3D environment

var ore_pool: Array = []
var is_mining: bool = false
var mine_progress: float = 0.0
var ore_types = ["copper_ore", "silver_ore", "gold_ore"]
var ore_chances = [0.6, 0.3, 0.1]

func mine() -> Dictionary:
	is_mining = true
	mine_progress = 0.0
	
	var drop = _roll_ore()
	var currency_gain = {
		"gold": randi_range(10, 25),
		"silver": randi_range(5, 15),
		"copper": randi_range(20, 50)
	}
	
	return {
		"ore": drop,
		"currency": currency_gain
	}

func _roll_ore() -> String:
	var rand = randf()
	var cumulative = 0.0
	
	for i in range(ore_types.size()):
		cumulative += ore_chances[i]
		if rand < cumulative:
			return ore_types[i]
	
	return ore_types[0]
