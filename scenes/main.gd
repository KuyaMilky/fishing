extends Node3D

# Main 3D scene controller

var character: Node3D
var camera: Camera3D
var hud: Control
var current_character: Dictionary = {}

func _ready():
	_setup_environment()
	_setup_camera()
	_setup_character()
	_setup_ui()
	_setup_input()

func _setup_environment():
	# Add directional light
	var light = DirectionalLight3D.new()
	light.rotation = Vector3(-PI/4, PI/4, 0)
	light.energy_multiplier = 1.5
	add_child(light)
	
	# Add environment
	var world_env = WorldEnvironment.new()
	var env = Environment.new()
	env.ambient_light_source = Environment.AMBIENT_LIGHT_DISABLED
	world_env.environment = env
	add_child(world_env)

func _setup_camera():
	camera = Camera3D.new()
	camera.position = Vector3(8, 6, 8)  # Isometric 45° angle
	camera.look_at(Vector3.ZERO, Vector3.UP)
	add_child(camera)

func _setup_character():
	# Create character from asset
	character = AssetManager.load_model("character", "res://assets/models/character.gltf")
	character.position = Vector3.ZERO
	add_child(character)
	
	# Add pickaxe as child
	var pickaxe = AssetManager.load_model("pickaxe", "res://assets/models/pickaxe.gltf")
	pickaxe.position = Vector3(0.5, 0.5, 0)
	character.add_child(pickaxe)
	
	# Add fishing rod as child
	var fishing_rod = AssetManager.load_model("fishing_rod", "res://assets/models/fishing_rod.gltf")
	fishing_rod.position = Vector3(-0.5, 0.5, 0)
	character.add_child(fishing_rod)

func _setup_ui():
	hud = Control.new()
	hud.anchor_left = 0
	hud.anchor_top = 0
	hud.anchor_right = 1
	hud.anchor_bottom = 1
	add_child(hud)
	
	# Add tab buttons
	_create_tab_buttons()
	# Add status display
	_create_status_display()

func _create_tab_buttons():
	var button_data = [
		{"text": "🎒 Inventory", "action": "tab_inventory"},
		{"text": "⚔️ Gear", "action": "tab_gear"},
		{"text": "🐟 Fish Dex", "action": "tab_fish"},
		{"text": "📖 Skills", "action": "tab_skills"},
		{"text": "📊 Stats", "action": "tab_stats"}
	]
	
	var h_box = HBoxContainer.new()
	h_box.anchor_bottom = 0.1
	h_box.offset_top = 10
	h_box.offset_left = 10
	for i in range(button_data.size()):
		var btn = Button.new()
		btn.text = button_data[i]["text"]
		btn.custom_minimum_size = Vector2(100, 40)
		h_box.add_child(btn)
	hud.add_child(h_box)

func _create_status_display():
	var label = Label.new()
	label.text = "⛏️ Mining: OFF | 🎣 Fishing: OFF"
	label.anchor_left = 0
	label.anchor_top = 0
	label.offset_left = 10
	label.offset_top = 10
	hud.add_child(label)

func _setup_input():
	pass

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_M:
			GameManager.toggle_mining()
		elif event.keycode == KEY_F:
			GameManager.toggle_fishing()
