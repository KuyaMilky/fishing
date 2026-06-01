extends Control

var ore_pool: Array = []
var is_mining: bool = false
var mine_progress: int = 0
var mine_progress_max: int = 100

var mining_yields = {
	"copper_ore": {"base": 0.5, "quantity": 1},
	"iron_ore": {"base": 0.3, "quantity": 1},
	"gold_ore": {"base": 0.15, "quantity": 1},
	"mithril_ore": {"base": 0.05, "quantity": 1}
}

var currency_drops = {
	"gold": 5,
	"silver": 10,
	"copper": 25
}

func _ready():
	if has_node("MiningButton"):
		$MiningButton.pressed.connect(_on_mine_pressed)

func _on_mine_pressed():
	if is_mining:
		return
	
	is_mining = true
	mine_progress = 0
	
	# Start mining animation
	if has_node("ProgressBar"):
		$ProgressBar.value = 0
		$ProgressBar.visible = true
	
	await get_tree().create_timer(2.0).timeout
	
	# Complete mining
	if is_mining:
		_complete_mining()

func _complete_mining():
	# Generate ore drops
	for ore_type in mining_yields:
		if randf() < mining_yields[ore_type]["base"]:
			ore_pool.append(ore_type)
	
	# Generate currency
	var gold_drop = randi_range(1, currency_drops["gold"])
	var silver_drop = randi_range(1, currency_drops["silver"])
	var copper_drop = randi_range(1, currency_drops["copper"])
	
	print("Mining complete!")
	print("Ores: ", ore_pool)
	print("Drops: Gold x%d, Silver x%d, Copper x%d" % [gold_drop, silver_drop, copper_drop])
	
	is_mining = false

func get_ore_pool() -> Array:
	return ore_pool

func clear_ore_pool():
	ore_pool.clear()
