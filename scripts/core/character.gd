class_name Character

var name: String
var level: int
var exp: int
var exp_to_level: int

var hp: int
var max_hp: int
var atk: int
var def: int
var agi: int

var stat_points: int
var gold: int
var silver: int
var copper: int

var inventory: Array = []
var equipment: Array = ["", "", "", "", "", "", "", "", "", ""]  # 10 slots
var collected_fish: Array = []
var skills: Array = []

var position: Vector2

func _init(data: Dictionary = {}):
	if data.is_empty():
		return
	
	name = data.get("name", "")
	level = data.get("level", 1)
	exp = data.get("exp", 0)
	exp_to_level = data.get("exp_to_level", 100)
	
	hp = data.get("hp", 100)
	max_hp = data.get("max_hp", 100)
	atk = data.get("atk", 10)
	def = data.get("def", 5)
	agi = data.get("agi", 8)
	
	stat_points = data.get("stat_points", 0)
	gold = data.get("gold", 0)
	silver = data.get("silver", 0)
	copper = data.get("copper", 0)
	
	inventory = data.get("inventory", [])
	equipment = data.get("equipment", [])
	collected_fish = data.get("collected_fish", [])
	skills = data.get("skills", [])
	
	position = Vector2(data.get("position", [256, 256]))

func to_dict() -> Dictionary:
	return {
		"name": name,
		"level": level,
		"exp": exp,
		"exp_to_level": exp_to_level,
		"hp": hp,
		"max_hp": max_hp,
		"atk": atk,
		"def": def,
		"agi": agi,
		"stat_points": stat_points,
		"gold": gold,
		"silver": silver,
		"copper": copper,
		"inventory": inventory,
		"equipment": equipment,
		"collected_fish": collected_fish,
		"skills": skills,
		"position": [position.x, position.y]
	}

func add_exp(amount: int):
	exp += amount
	while exp >= exp_to_level:
		exp -= exp_to_level
		level_up()

func level_up():
	level += 1
	exp_to_level = int(exp_to_level * 1.1)
	stat_points += 5
	max_hp += 10
	hp = max_hp


func add_item(item_id: String, quantity: int = 1) -> bool:
	# Check if item already in inventory
	for inv_item in inventory:
		if inv_item["id"] == item_id:
			inv_item["quantity"] += quantity
			return true
	
	# Add new item
	inventory.append({"id": item_id, "quantity": quantity})
	return true

func remove_item(item_id: String, quantity: int = 1) -> bool:
	for i in range(inventory.size()):
		if inventory[i]["id"] == item_id:
			inventory[i]["quantity"] -= quantity
			if inventory[i]["quantity"] <= 0:
				inventory.remove_at(i)
			return true
	return false

func equip_item(item_id: String, slot: int) -> bool:
	if slot < 0 or slot >= 10:
		return false
	equipment[slot] = item_id
	return true

func unequip_item(slot: int) -> bool:
	if slot < 0 or slot >= 10:
		return false
	equipment[slot] = ""
	return true
