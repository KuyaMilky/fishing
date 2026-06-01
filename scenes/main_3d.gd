extends Node3D

# Main 3D game scene

var player_model: Node3D
var camera: Camera3D
var player_data: Dictionary = {}

func _ready():
	_setup_scene()
	_setup_camera()
	_create_environments()
	_create_player()

func _setup_scene():
	pass

func _setup_camera():
	camera = Camera3D.new()
	camera.position = Vector3(0, 5, 10)
	camera.look_at(Vector3(0, 1, 0), Vector3.UP)
	add_child(camera)

func _create_environments():
	# Mountain area
	var mountain = CSGBox3D.new()
	mountain.size = Vector3(50, 5, 50)
	mountain.position = Vector3(-30, 0, 0)
	add_child(mountain)
	
	# Sea area
	var sea = CSGBox3D.new()
	sea.size = Vector3(50, 2, 50)
	sea.position = Vector3(30, 0, 0)
	sea.material = StandardMaterial3D.new()
	sea.material.albedo_color = Color.BLUE
	add_child(sea)

func _create_player():
	player_data = GameManager.create_player("Hero")
	player_model = Node3D.new()
	player_model.position = Vector3(-30, 3, 0)
	add_child(player_model)
	
	# Simple player representation
	var player_mesh = MeshInstance3D.new()
	var capsule = CapsuleMesh.new()
	capsule.radius = 0.5
	capsule.height = 2.0
	player_mesh.mesh = capsule
	player_mesh.material_override = StandardMaterial3D.new()
	player_mesh.material_override.albedo_color = Color.RED
	player_model.add_child(player_mesh)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_M:
			_mine()
		elif event.keycode == KEY_F:
			_fish()
		elif event.keycode == KEY_I:
			_open_inventory()

func _mine():
	print("[MINING] Mining ore...")
	var ores = ["copper_ore", "silver_ore", "gold_ore"]
	var ore = ores[randi() % ores.size()]
	player_data["inventory"].append({"id": ore, "quantity": 1})
	player_data["gold"] += randi_range(5, 15)
	print("Mined: %s" % ore)

func _fish():
	print("[FISHING] Casting line...")
	if ItemDatabase.fish_species.size() > 0:
		var fish = ItemDatabase.fish_species[randi() % ItemDatabase.fish_species.size()]
		player_data["inventory"].append({"id": fish["id"], "quantity": 1})
		player_data = CharacterManager.add_fish_to_collection(player_data, fish["id"])
		print("Caught: %s" % fish["name"])

func _open_inventory():
	print("=== INVENTORY ===")
	for item in player_data["inventory"]:
		print("  - %s x%d" % [item["id"], item["quantity"]])
