extends Control

var character: Character = null
var inventory_slots: Array = []
var selected_item: Dictionary = {}

func _ready():
	if has_node("CloseButton"):
		$CloseButton.pressed.connect(queue_free)

func set_character(char: Character):
	character = char
	_refresh_inventory()

func _refresh_inventory():
	if not character:
		return
	
	# Clear existing slots
	if has_node("ScrollContainer/VBoxContainer"):
		for child in $ScrollContainer/VBoxContainer.get_children():
			child.queue_free()
	
	# Create item slots
	for inv_item in character.inventory:
		var item_data = ItemDatabase.get_item(inv_item["id"])
		if item_data.is_empty():
			continue
		
		var slot = _create_slot(item_data, inv_item["quantity"])
		inventory_slots.append(slot)

func _create_slot(item_data: Dictionary, quantity: int) -> PanelContainer:
	var slot = PanelContainer.new()
	var vbox = VBoxContainer.new()
	
	var item_label = Label.new()
	item_label.text = "%s x%d" % [item_data.get("name", "Unknown"), quantity]
	item_label.add_theme_color_override("font_color", ItemDatabase.get_rarity_color(item_data.get("rarity", "common")))
	
	var value_label = Label.new()
	value_label.text = "Value: %d gold" % item_data.get("value", 0)
	value_label.add_theme_font_size_override("font_size", 10)
	
	vbox.add_child(item_label)
	vbox.add_child(value_label)
	slot.add_child(vbox)
	slot.mouse_entered.connect(func(): selected_item = item_data)
	
	return slot
