extends Node

# Network/Multiplayer manager for trading and arena

var connected_players: Array = []
var trading_board: Array = []

func _ready():
	pass

func post_trade_offer(player_name: String, item_id: String, price: int) -> bool:
	var offer = {
		"seller": player_name,
		"item_id": item_id,
		"price": price,
		"timestamp": Time.get_ticks_msec()
	}
	trading_board.append(offer)
	print("Trade posted by %s: %s for %d gold" % [player_name, item_id, price])
	return true

func get_available_trades() -> Array:
	return trading_board

func purchase_item(buyer: String, trade_index: int) -> bool:
	if trade_index >= 0 and trade_index < trading_board.size():
		var trade = trading_board[trade_index]
		print("%s purchased %s from %s" % [buyer, trade["item_id"], trade["seller"]])
		trading_board.remove_at(trade_index)
		return true
	return false

func add_player_to_arena(player_name: String) -> bool:
	if not player_name in connected_players:
		connected_players.append(player_name)
		print("%s joined arena" % player_name)
		return true
	return false

func remove_player_from_arena(player_name: String) -> bool:
	if player_name in connected_players:
		connected_players.erase(player_name)
		print("%s left arena" % player_name)
		return true
	return false

func get_arena_players() -> Array:
	return connected_players
