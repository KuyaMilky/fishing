extends Node

# Arena system manager

var arena_active: bool = false
var arena_players: Dictionary = {}  # player_name -> {position, health, skills}
var arena_matches: Array = []

func activate_arena():
	arena_active = true
	print("=== ARENA ACTIVATED ===")

func deactivate_arena():
	arena_active = false
	_distribute_rewards()

func register_arena_player(player_name: String) -> bool:
	if not arena_players.has(player_name):
		arena_players[player_name] = {
			"health": 100,
			"position": Vector3.ZERO,
			"alive": true,
			"kills": 0
		}
		NetworkManager.add_player_to_arena(player_name)
		return true
	return false

func unregister_arena_player(player_name: String) -> bool:
	if arena_players.has(player_name):
		arena_players.erase(player_name)
		NetworkManager.remove_player_from_arena(player_name)
		return true
	return false

func record_kill(killer: String, victim: String, points: int = 10) -> bool:
	if arena_players.has(killer):
		arena_players[killer]["kills"] += 1
		return true
	return false

func _distribute_rewards():
	var sorted_players = arena_players.keys()
	sorted_players.sort_custom(func(a, b): return arena_players[a]["kills"] > arena_players[b]["kills"])
	
	for i in range(min(3, sorted_players.size())):
		var player_name = sorted_players[i]
		var reward_points = [50, 30, 10][i]
		print("%s earned %d arena points" % [player_name, reward_points])

func reset_arena():
	arena_players.clear()
	arena_active = false
