extends GridContainer

var character: Character = null
var equipment_slots: Array = []
var slot_positions = [
	"Head", "Chest", "Hands", "Legs", "Feet",
	"Weapon", "Shield", "Ring1", "Ring2", "Amulet"
]

func _ready():
	columns = 5
	_create_slots()

func _create_slots():
	for i in range(10):
		var slot = PanelContainer.new()
		slot.custom_minimum_size = Vector2(60, 60)
		
		var vbox = VBoxContainer.new()
		var label = Label.new()
		label.text = slot_positions[i]
		label.add_theme_font_size_override("font_size", 8)
		
		vbox.add_child(label)
		slot.add_child(vbox)
		add_child(slot)
		equipment_slots.append(slot)

func set_character(char: Character):
	character = char
	_refresh_equipment()

func _refresh_equipment():
	if not character:
		return
	
	for i in range(10):
		var item_id = character.equipment[i]
		if item_id and not item_id.is_empty():
			var item_data = ItemDatabase.get_item(item_id)
			var label = equipment_slots[i].get_child(0).get_child(0)
			label.text = item_data.get("name", "Unknown")
			equipment_slots[i].add_theme_color_override("panel_bg_color", ItemDatabase.get_rarity_color(item_data.get("rarity", "common")))
