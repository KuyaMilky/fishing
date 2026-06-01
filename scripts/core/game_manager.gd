extends Node

var current_character: Character = null
var current_scene: String = "main"

func _ready():
	var start_screen = $UI/StartScreen
	var start_button = start_screen.get_node("VBoxContainer/StartButton")
	start_button.pressed.connect(_on_start_pressed)

func _on_start_pressed():
	var name_input = $UI/StartScreen/VBoxContainer/NameInput
	var character_name = name_input.text.strip_edges()
	
	if character_name.is_empty():
		print("Please enter a character name")
		return
	
	# Load or create character
	current_character = load_character(character_name)
	if current_character == null:
		current_character = create_character(character_name)
		save_character(current_character)
	
	# Start game
	$UI/StartScreen.visible = false
	$World.visible = true
	_initialize_world()

func create_character(name: String) -> Dictionary:
	return {
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
		"equipment": ["", "", "", "", "", "", "", "", "", ""],  # 10 slots
		"collected_fish": [],
		"skills": [],
		"position": Vector2(256, 256),
		"created_at": Time.get_ticks_msec()
	}

func load_character(name: String) -> Dictionary:
	var save_path = "user://characters/%s.json" % name
	if ResourceLoader.exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			var json = JSON.parse_string(json_string)
			return json
	return null

func save_character(character: Dictionary):
	var dir = DirAccess.open("user://")
	if dir:
		if not dir.dir_exists("characters"):
			dir.make_dir("characters")
	
	var save_path = "user://characters/%s.json" % character["name"]
	var json_string = JSON.stringify(character)
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		print("Character saved: %s" % save_path)

func _initialize_world():
	# Update UI with character stats
	var stats_panel = $World/HUD/StatsPanel/VBoxContainer
	stats_panel.get_node("NameLabel").text = "Character: %s" % current_character["name"]
	stats_panel.get_node("LevelLabel").text = "Level: %d" % current_character["level"]
	stats_panel.get_node("HealthLabel").text = "HP: %d/%d" % [current_character["hp"], current_character["max_hp"]]
	stats_panel.get_node("CurrencyLabel").text = "Gold: %d | Silver: %d | Copper: %d" % [current_character["gold"], current_character["silver"], current_character["copper"]]

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if current_character:
			save_character(current_character)
		get_tree().quit()
