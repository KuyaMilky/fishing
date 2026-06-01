extends Node

# Asset manager - dynamically loads 3D models and textures

var loaded_assets: Dictionary = {}

func load_model(asset_id: String, path: String) -> Node3D:
	if asset_id in loaded_assets:
		return loaded_assets[asset_id].duplicate()
	
	if ResourceLoader.exists(path):
		var model = load(path).instantiate()
		loaded_assets[asset_id] = model
		print("[AssetMgr] Loaded: %s" % asset_id)
		return model.duplicate()
	else:
		print("[AssetMgr] Asset not found: %s" % path)
		return _create_placeholder(asset_id)

func _create_placeholder(asset_id: String) -> Node3D:
	# Create placeholder mesh until real asset is available
	var mesh_instance = MeshInstance3D.new()
	var material = StandardMaterial3D.new()
	
	match asset_id:
		"character":
			var capsule = CapsuleMesh.new()
			capsule.radius = 0.4
			capsule.height = 1.8
			mesh_instance.mesh = capsule
			material.albedo_color = Color.RED
		
		"pickaxe":
			var box = BoxMesh.new()
			box.size = Vector3(0.3, 0.1, 1.0)
			mesh_instance.mesh = box
			material.albedo_color = Color.GRAY
		
		"fishing_rod":
			var cyl = CylinderMesh.new()
			cyl.radius = 0.05
			cyl.height = 1.5
			mesh_instance.mesh = cyl
			material.albedo_color = Color.BROWN
		
		_:
			var sphere = SphereMesh.new()
			sphere.radius = 0.2
			mesh_instance.mesh = sphere
			material.albedo_color = Color.WHITE
	
	mesh_instance.set_surface_override_material(0, material)
	return mesh_instance
