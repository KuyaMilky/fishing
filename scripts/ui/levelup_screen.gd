extends Control

var character: Character = null
var stat_labels = {}
var point_labels = {}

func _ready():
	_setup_ui()

func _setup_ui():
	var stats = ["hp", "atk", "def", "agi"]
	for stat in stats:
		if has_node("VBoxContainer/%sLabel" % stat.to_upper()):
			stat_labels[stat] = get_node("VBoxContainer/%sLabel" % stat.to_upper())
		
		if has_node("VBoxContainer/%sUpButton" % stat.to_upper()):
			get_node("VBoxContainer/%sUpButton" % stat.to_upper()).pressed.connect(_on_stat_up.bindv([stat]))

func set_character(char: Character):
	character = char
	_refresh_display()

func _refresh_display():
	if not character:
		return
	
	if has_node("VBoxContainer/PointsLabel"):
		$VBoxContainer/PointsLabel.text = "Points Available: %d" % character.stat_points
	
	if stat_labels.has("hp"):
		stat_labels["hp"].text = "HP: %d" % character.max_hp
	if stat_labels.has("atk"):
		stat_labels["atk"].text = "ATK: %d" % character.atk
	if stat_labels.has("def"):
		stat_labels["def"].text = "DEF: %d" % character.def
	if stat_labels.has("agi"):
		stat_labels["agi"].text = "AGI: %d" % character.agi

func _on_stat_up(stat: String):
	if character.stat_points <= 0:
		return
	
	match stat:
		"hp":
			character.max_hp += 5
			character.hp = character.max_hp
		"atk":
			character.atk += 2
		"def":
			character.def += 2
		"agi":
			character.agi += 1
	
	character.stat_points -= 1
	_refresh_display()
