extends Node

# Autoload for managing game state

var current_player: Dictionary = {}
var is_in_arena: bool = false
var arena_schedule = {
	"start_times": [10, 20],  # 10 AM and 8 PM (20:00)
	"duration": 3600  # 1 hour
}

func _ready():
	set_process(true)

func _process(delta):
	var current_hour = Time.get_ticks_msec() / 1000 / 3600 % 24
	if current_hour in arena_schedule["start_times"]:
		if not is_in_arena:
			notify_arena_start()
			is_in_arena = true
	else:
		is_in_arena = false

func create_player(name: String) -> Dictionary:
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
		"arena_points": 0,
		"inventory": [],
		"equipment": {
			"headgear": "",
			"earrings": "",
			"necklace": "",
			"ring": "",
			"bracelet": "",
			"upper_armor": "",
			"lower_armor": "",
			"gloves": "",
			"boots": "",
			"weapon": ""
		},
		"skills": [],
		"collected_fish": [],
		"created_at": Time.get_ticks_msec()
	}

func save_player(player: Dictionary):
	var save_path = "user://players/%s.json" % player["name"]
	var dir = DirAccess.open("user://")
	if not dir.dir_exists("players"):
		dir.make_dir("players")
	var json_str = JSON.stringify(player)
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(json_str)
		print("Player saved: %s" % save_path)

func load_player(name: String) -> Dictionary:
	var save_path = "user://players/%s.json" % name
	if ResourceLoader.exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file:
			var json_str = file.get_as_text()
			var data = JSON.parse_string(json_str)
			if data:
				print("Player loaded: %s" % name)
				return data
	return {}

func notify_arena_start():
	print("ARENA IS NOW OPEN!")
	if has_node("/root/Main/UI/ArenaNotification"):
		var notif = get_node("/root/Main/UI/ArenaNotification")
		notif.show()
