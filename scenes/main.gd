extends Node3D

# Main 3D game scene with procedural models and animations

var character_model: Node3D
var camera: Camera3D
var hud: Control
var current_character: Dictionary = {}
var equipment_displays: Dictionary = {}  # Slot -> visual node
var animation_tween: Tween
var is_mining: bool = false
var is_fishing: bool = false
var mining_timer: float = 0.0
var fishing_timer: float = 0.0

func _ready():
	set_process(true)
	_setup_environment()
	_setup_camera()
	_create_scene()
	_setup_ui()
	_setup_input()
	
	current_character = CharacterManager.create_default_character()
	print("[Game] Ready to play!")

func _setup_environment():
	# Lighting
	var light = DirectionalLight3D.new()
	light.rotation = Vector3(-PI/4, PI/4, 0)
	light.energy_multiplier = 2.0
	add_child(light)
	
	# Ambient light
	var world_env = WorldEnvironment.new()
	var env = Environment.new()
	env.ambient_light_source = Environment.AMBIENT_LIGHT_DISABLED
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.3, 0.5, 0.7)
	world_env.environment = env
	add_child(world_env)

func _setup_camera():
	camera = Camera3D.new()
	camera.position = Vector3(12, 8, 12)  # Isometric 45° angle
	camera.look_at(Vector3(0, 1, 0), Vector3.UP)
	add_child(camera)
	
	set_viewport(get_viewport())

func _create_scene():
	# Mountain
	var mountain = ProceduralModelGenerator.create_mountain()
	mountain.position = Vector3(-15, 0, 0)
	add_child(mountain)
	
	# Sea
	var sea = ProceduralModelGenerator.create_sea()
	sea.position = Vector3(20, 0, 0)
	add_child(sea)
	
	# Character
	character_model = ProceduralModelGenerator.create_character_body()
	character_model.position = Vector3(-15, 1.5, 0)
	add_child(character_model)
	
	# Initial equipment
	_equip_item("pickaxe", "pickaxe")
	_equip_item("fishing_rod", "fishing_rod")

func _equip_item(slot: String, item_id: String) -> void:
	# Remove old equipment visual
	if equipment_displays.has(slot):
		equipment_displays[slot].queue_free()
	
	var equipment_model: Node3D = null
	
	match item_id:
		"pickaxe":
			equipment_model = ProceduralModelGenerator.create_pickaxe()
		"sword":
			equipment_model = ProceduralModelGenerator.create_sword()
		"shield":
			equipment_model = ProceduralModelGenerator.create_shield()
		"helmet":
			equipment_model = ProceduralModelGenerator.create_helmet()
		"armor":
			equipment_model = ProceduralModelGenerator.create_armor()
		"fishing_rod":
			equipment_model = ProceduralModelGenerator.create_fishing_rod()
	
	if equipment_model:
		# Position based on slot
		match slot:
			"pickaxe", "weapon":
				equipment_model.position = Vector3(0.5, 0.3, 0)
			"fishing_rod":
				equipment_model.position = Vector3(-0.5, 0.3, 0)
			"helmet":
				equipment_model.position = Vector3(0, 0.8, 0)
			"armor":
				equipment_model.position = Vector3(0, 0.1, 0)
			"shield":
				equipment_model.position = Vector3(-0.4, 0.2, 0)
		
		character_model.add_child(equipment_model)
		equipment_displays[slot] = equipment_model
		print("[Equipment] Equipped %s to %s" % [item_id, slot])

func _setup_ui():
	hud = Control.new()
	hud.anchor_left = 0
	hud.anchor_top = 0
	hud.anchor_right = 1
	hud.anchor_bottom = 1
	add_child(hud)
	
	# Status panel
	var status_label = Label.new()
	status_label.text = "⛏️ AUTO-MINE: OFF | 🎣 AUTO-FISH: OFF"
	status_label.add_theme_font_size_override("font_size", 18)
	status_label.offset_left = 20
	status_label.offset_top = 20
	hud.add_child(status_label)
	
	# Character stats
	var stats_label = Label.new()
	stats_label.text = "HP: 100/100 | ATK: 10 | DEF: 5 | AGI: 8"
	stats_label.add_theme_font_size_override("font_size", 16)
	stats_label.offset_left = 20
	stats_label.offset_top = 60
	hud.add_child(stats_label)
	
	# Inventory count
	var inventory_label = Label.new()
	inventory_label.text = "🎒 Items: 0 | Gold: 0"
	inventory_label.add_theme_font_size_override("font_size", 16)
	inventory_label.offset_left = 20
	inventory_label.offset_top = 90
	hud.add_child(inventory_label)
	
	# Controls help
	var help_label = Label.new()
	help_label.text = "M: Toggle Mining | F: Toggle Fishing | I: Inventory | E: Equipment | S: Stats"
	help_label.add_theme_font_size_override("font_size", 12)
	help_label.offset_left = 20
	help_label.offset_bottom = -30
	help_label.anchor_bottom = 1
	hud.add_child(help_label)

func _setup_input():
	pass

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_M:
			toggle_mining()
		elif event.keycode == KEY_F:
			toggle_fishing()
		elif event.keycode == KEY_I:
			show_inventory()
		elif event.keycode == KEY_E:
			show_equipment()
		elif event.keycode == KEY_S:
			show_stats()
		elif event.keycode == KEY_1:
			_equip_item("weapon", "sword")
		elif event.keycode == KEY_2:
			_equip_item("offhand", "shield")
		elif event.keycode == KEY_3:
			_equip_item("headgear", "helmet")
		elif event.keycode == KEY_4:
			_equip_item("upper_armor", "armor")

func _process(delta):
	if is_mining:
		mining_timer += delta
		if mining_timer >= 3.0:
			_perform_mine()
			mining_timer = 0.0
	
	if is_fishing:
		fishing_timer += delta
		if fishing_timer >= 5.0:
			_perform_fish()
			fishing_timer = 0.0

func toggle_mining():
	is_mining = !is_mining
	print("[Mining] %s" % ("ON" if is_mining else "OFF"))
	if is_mining:
		_play_mining_animation()

func toggle_fishing():
	is_fishing = !is_fishing
	print("[Fishing] %s" % ("ON" if is_fishing else "OFF"))
	if is_fishing:
		_play_fishing_animation()

func _perform_mine():
	var ore = _roll_ore()
	if ore:
		current_character["inventory"].append({"id": ore["id"], "quantity": 1})
		current_character["gold"] += ore.get("value", 1)
		print("⛏️ Mined: %s" % ore["name"])
		_play_mining_animation()

func _perform_fish():
	var fish = _roll_fish()
	if fish:
		var found = false
		for inv_item in current_character["inventory"]:
			if inv_item["id"] == fish["id"]:
				inv_item["quantity"] += 1
				found = true
				break
		
		if not found:
			current_character["inventory"].append({"id": fish["id"], "quantity": 1})
		
		if not fish["id"] in current_character["collected_fish"]:
			current_character["collected_fish"].append(fish["id"])
			print("🎣 NEW: %s (%s)" % [fish["name"], fish["rarity"]])
		else:
			print("🎣 Caught: %s" % fish["name"])
		
		_play_fishing_animation()

func _play_mining_animation():
	if animation_tween:
		animation_tween.kill()
	
	var pickaxe = equipment_displays.get("pickaxe")
	if pickaxe:
		animation_tween = create_tween()
		animation_tween.set_trans(Tween.TRANS_SINE)
		animation_tween.tween_property(pickaxe, "rotation:x", PI/3, 0.3)
		animation_tween.tween_property(pickaxe, "rotation:x", 0, 0.3)

func _play_fishing_animation():
	if animation_tween:
		animation_tween.kill()
	
	var rod = equipment_displays.get("fishing_rod")
	if rod:
		animation_tween = create_tween()
		animation_tween.set_trans(Tween.TRANS_SINE)
		animation_tween.tween_property(rod, "rotation:z", PI/3, 0.4)
		animation_tween.tween_property(rod, "rotation:z", -PI/3, 0.4)

func _roll_ore() -> Dictionary:
	var ores = ItemDatabase.items.values().filter(func(x): return x.get("type") == "ore")
	if ores.size() > 0:
		return ores[randi() % ores.size()]
	return {}

func _roll_fish() -> Dictionary:
	var fish_list = ItemDatabase.fish_species
	var rarity = _roll_rarity()
	var candidates = fish_list.filter(func(x): return x.get("rarity") == rarity)
	if candidates.size() > 0:
		return candidates[randi() % candidates.size()]
	return {}

func _roll_rarity() -> String:
	var weights = {
		"common": 0.60,
		"uncommon": 0.25,
		"rare": 0.10,
		"epic": 0.04,
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

func show_inventory():
	print("=== INVENTORY ===")
	for item in current_character["inventory"]:
		var item_data = ItemDatabase.get_item(item["id"])
		print("  %s x%d (Value: %d)" % [item_data.get("name", item["id"]), item["quantity"], item_data.get("value", 0)])
	print("Gold: %d" % current_character["gold"])

func show_equipment():
	print("=== EQUIPMENT ===")
	for slot in current_character["equipment"]:
		var equipped = current_character["equipment"][slot]
		if equipped:
			var item = ItemDatabase.get_item(equipped)
			print("  %s: %s" % [slot, item.get("name", equipped)])

func show_stats():
	print("=== STATS ===")
	print("Level: %d" % current_character["level"])
	print("HP: %d/%d" % [current_character["hp"], current_character["max_hp"]])
	print("ATK: %d" % current_character["atk"])
	print("DEF: %d" % current_character["def"])
	print("AGI: %d" % current_character["agi"])
	print("Points available: %d" % current_character["stat_points"])
