extends Node3D

# Procedural model generator for characters, equipment, and fish

class_name ProceduralModelGenerator

static func create_character_body() -> Node3D:
	var root = Node3D.new()
	
	# Head
	var head = _create_sphere(0.3, Color.WHEAT)
	head.position = Vector3(0, 0.7, 0)
	root.add_child(head)
	
	# Body
	var body = _create_capsule(0.25, 0.6, Color(0.8, 0.2, 0.2))
	body.position = Vector3(0, 0.2, 0)
	root.add_child(body)
	
	# Arms
	var left_arm = _create_capsule(0.1, 0.5, Color.PEACHPUFF)
	left_arm.position = Vector3(-0.35, 0.3, 0)
	root.add_child(left_arm)
	
	var right_arm = _create_capsule(0.1, 0.5, Color.PEACHPUFF)
	right_arm.position = Vector3(0.35, 0.3, 0)
	root.add_child(right_arm)
	
	# Legs
	var left_leg = _create_capsule(0.12, 0.5, Color(0.2, 0.2, 0.4))
	left_leg.position = Vector3(-0.15, -0.3, 0)
	root.add_child(left_leg)
	
	var right_leg = _create_capsule(0.12, 0.5, Color(0.2, 0.2, 0.4))
	right_leg.position = Vector3(0.15, -0.3, 0)
	root.add_child(right_leg)
	
	return root

static func create_pickaxe() -> Node3D:
	var root = Node3D.new()
	
	# Handle
	var handle = _create_cylinder(0.08, 1.2, Color.BROWN)
	handle.position = Vector3(0, 0, 0)
	root.add_child(handle)
	
	# Head
	var head = _create_box(Vector3(0.4, 0.2, 0.1), Color.GRAY)
	head.position = Vector3(0, 0.7, 0)
	root.add_child(head)
	
	return root

static func create_sword() -> Node3D:
	var root = Node3D.new()
	
	# Blade
	var blade = _create_box(Vector3(0.15, 0.8, 0.05), Color(0.7, 0.7, 1.0))
	blade.position = Vector3(0, 0.4, 0)
	root.add_child(blade)
	
	# Guard
	var guard = _create_box(Vector3(0.4, 0.1, 0.1), Color.GOLD)
	guard.position = Vector3(0, 0, 0)
	root.add_child(guard)
	
	# Handle
	var handle = _create_cylinder(0.1, 0.3, Color.BROWN)
	handle.position = Vector3(0, -0.2, 0)
	root.add_child(handle)
	
	return root

static func create_shield() -> Node3D:
	var root = Node3D.new()
	
	# Main shield
	var shield = _create_box(Vector3(0.5, 0.6, 0.08), Color.DARK_RED)
	shield.position = Vector3(0, 0.1, 0)
	root.add_child(shield)
	
	# Emblem
	var emblem = _create_sphere(0.15, Color.GOLD)
	emblem.position = Vector3(0, 0.15, 0.05)
	root.add_child(emblem)
	
	return root

static func create_helmet() -> Node3D:
	var root = Node3D.new()
	
	# Main helmet
	var helmet = _create_sphere(0.35, Color.GRAY)
	helmet.position = Vector3(0, 0, 0)
	root.add_child(helmet)
	
	# Visor
	var visor = _create_box(Vector3(0.3, 0.15, 0.05), Color.DARK_GRAY)
	visor.position = Vector3(0, -0.1, 0.2)
	root.add_child(visor)
	
	return root

static func create_armor() -> Node3D:
	var root = Node3D.new()
	
	# Chest plate
	var chest = _create_box(Vector3(0.4, 0.5, 0.1), Color(0.5, 0.5, 0.6))
	chest.position = Vector3(0, 0, 0)
	root.add_child(chest)
	
	# Shoulder guards
	var left_shoulder = _create_sphere(0.15, Color(0.4, 0.4, 0.5))
	left_shoulder.position = Vector3(-0.25, 0.2, 0)
	root.add_child(left_shoulder)
	
	var right_shoulder = _create_sphere(0.15, Color(0.4, 0.4, 0.5))
	right_shoulder.position = Vector3(0.25, 0.2, 0)
	root.add_child(right_shoulder)
	
	return root

static func create_fish(fish_data: Dictionary) -> Node3D:
	var root = Node3D.new()
	
	var rarity = fish_data.get("rarity", "common")
	var size = fish_data.get("size", "small")
	
	var scale = _get_fish_scale(size)
	var color = _get_fish_color(rarity)
	
	# Body
	var body = _create_box(Vector3(0.3, 0.2, 0.15) * scale, color)
	body.position = Vector3(0, 0, 0)
	root.add_child(body)
	
	# Tail
	var tail = _create_box(Vector3(0.2, 0.15, 0.08) * scale, color)
	tail.position = Vector3(0.25 * scale, 0, 0)
	root.add_child(tail)
	
	# Fin
	var fin = _create_box(Vector3(0.08, 0.2, 0.04) * scale, Color(color.r * 0.8, color.g * 0.8, color.b))
	fin.position = Vector3(0, 0.15 * scale, 0)
	root.add_child(fin)
	
	# Eye
	var eye = _create_sphere(0.05 * scale, Color.BLACK)
	eye.position = Vector3(-0.1 * scale, 0.05 * scale, 0.08 * scale)
	root.add_child(eye)
	
	return root

static func create_fishing_rod() -> Node3D:
	var root = Node3D.new()
	
	# Rod
	var rod = _create_cylinder(0.04, 1.5, Color.BROWN)
	rod.rotation = Vector3(PI/4, 0, 0)
	rod.position = Vector3(0, 0, 0)
	root.add_child(rod)
	
	# Reel
	var reel = _create_cylinder(0.12, 0.08, Color.GRAY)
	reel.position = Vector3(0, 0.3, 0)
	root.add_child(reel)
	
	# Line
	var line = _create_cylinder(0.01, 2.0, Color.TAN)
	line.position = Vector3(0.2, 0.2, 0)
	root.add_child(line)
	
	return root

static func create_mountain() -> Node3D:
	var root = Node3D.new()
	
	# Main mountain
	var mountain = _create_box(Vector3(20, 10, 20), Color(0.6, 0.5, 0.4))
	mountain.position = Vector3(-15, 5, 0)
	root.add_child(mountain)
	
	# Snow cap
	var snow = _create_box(Vector3(20, 3, 20), Color.WHITE)
	snow.position = Vector3(-15, 12, 0)
	root.add_child(snow)
	
	# Mining area rocks
	for i in range(5):
		var rock = _create_sphere(randf_range(1.0, 2.0), Color(0.4, 0.4, 0.4))
		rock.position = Vector3(-15 + randf_range(-5, 5), 6, randf_range(-5, 5))
		root.add_child(rock)
	
	return root

static func create_sea() -> Node3D:
	var root = Node3D.new()
	
	# Water
	var water = _create_box(Vector3(30, 1, 30), Color(0.2, 0.6, 0.8))
	water.position = Vector3(20, 0, 0)
	root.add_child(water)
	
	return root

static func _create_sphere(radius: float, color: Color) -> MeshInstance3D:
	var mesh_instance = MeshInstance3D.new()
	var sphere_mesh = SphereMesh.new()
	sphere_mesh.radius = radius
	sphere_mesh.height = radius * 2
	mesh_instance.mesh = sphere_mesh
	
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	mesh_instance.set_surface_override_material(0, material)
	
	return mesh_instance

static func _create_cylinder(radius: float, height: float, color: Color) -> MeshInstance3D:
	var mesh_instance = MeshInstance3D.new()
	var cylinder_mesh = CylinderMesh.new()
	cylinder_mesh.radius = radius
	cylinder_mesh.height = height
	mesh_instance.mesh = cylinder_mesh
	
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	mesh_instance.set_surface_override_material(0, material)
	
	return mesh_instance

static func _create_box(size: Vector3, color: Color) -> MeshInstance3D:
	var mesh_instance = MeshInstance3D.new()
	var box_mesh = BoxMesh.new()
	box_mesh.size = size
	mesh_instance.mesh = box_mesh
	
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	mesh_instance.set_surface_override_material(0, material)
	
	return mesh_instance

static func _create_capsule(radius: float, height: float, color: Color) -> MeshInstance3D:
	var mesh_instance = MeshInstance3D.new()
	var capsule_mesh = CapsuleMesh.new()
	capsule_mesh.radius = radius
	capsule_mesh.height = height
	mesh_instance.mesh = capsule_mesh
	
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	mesh_instance.set_surface_override_material(0, material)
	
	return mesh_instance

static func _get_fish_scale(size: String) -> float:
	match size:
		"tiny":
			return 0.3
		"small":
			return 0.6
		"medium":
			return 1.0
		"large":
			return 1.5
		"xlarge":
			return 2.0
		"huge":
			return 3.0
		"colossal":
			return 5.0
		_:
			return 1.0

static func _get_fish_color(rarity: String) -> Color:
	match rarity:
		"common":
			return Color(0.8, 0.8, 0.6)
		"uncommon":
			return Color(0.6, 0.9, 0.6)
		"rare":
			return Color(0.6, 0.8, 1.0)
		"epic":
			return Color(0.9, 0.6, 1.0)
		"legendary":
			return Color(1.0, 0.8, 0.3)
		"mythic":
			return Color(1.0, 0.3, 0.8)
		_:
			return Color.WHITE
