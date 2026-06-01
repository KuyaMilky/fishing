extends Control

var fish_species_data: Array = []
var caught_fish: Array = []
var is_fishing: bool = false
var fish_catch_rate: float = 0.3

var fish_rarity_weights = {
	"common": 0.50,
	"uncommon": 0.30,
	"rare": 0.12,
	"epic": 0.05,
	"legendary": 0.02,
	"mythic": 0.01
}

func _ready():
	fish_species_data = ItemDatabase.fish_species
	if has_node("FishButton"):
		$FishButton.pressed.connect(_on_fish_pressed)

func _on_fish_pressed():
	if is_fishing:
		return
	
	is_fishing = true
	
	# Start fishing animation
	if has_node("FishingProgressBar"):
		$FishingProgressBar.value = 0
		$FishingProgressBar.visible = true
	
	await get_tree().create_timer(3.0).timeout
	
	if is_fishing:
		_attempt_catch()

func _attempt_catch():
	if randf() < fish_catch_rate:
		var fish = _get_random_fish()
		caught_fish.append(fish)
		print("Caught: %s (Rarity: %s)" % [fish["name"], fish["rarity"]])
	else:
		print("No catch this time.")
	
	is_fishing = false

func _get_random_fish() -> Dictionary:
	var rarity = _roll_rarity()
	var candidates = []
	
	# Filter fish by rarity
	for fish in fish_species_data:
		if fish.get("rarity") == rarity:
			candidates.append(fish)
	
	if candidates.size() > 0:
		return candidates[randi() % candidates.size()]
	
	return {"name": "Unknown Fish", "rarity": rarity, "value": 10}

func _roll_rarity() -> String:
	var roll = randf()
	var cumulative = 0.0
	
	for rarity in ["common", "uncommon", "rare", "epic", "legendary", "mythic"]:
		cumulative += fish_rarity_weights.get(rarity, 0.0)
		if roll <= cumulative:
			return rarity
	
	return "common"

func get_caught_fish() -> Array:
	return caught_fish

func clear_caught_fish():
	caught_fish.clear()
