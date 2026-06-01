extends VBoxContainer

var character: Character = null
var skill_slots: Array = []

func _ready():
	pass

func set_character(char: Character):
	character = char
	_refresh_skills()

func _refresh_skills():
	if not character:
		return
	
	# Clear existing skills
	for child in get_children():
		child.queue_free()
	
	# Add skill items
	for skill_id in character.skills:
		var skill_data = ItemDatabase.get_item(skill_id)
		if skill_data.is_empty():
			continue
		
		var skill_item = _create_skill_item(skill_data)
		add_child(skill_item)

func _create_skill_item(skill_data: Dictionary) -> PanelContainer:
	var panel = PanelContainer.new()
	var vbox = VBoxContainer.new()
	
	var name_label = Label.new()
	name_label.text = skill_data.get("name", "Unknown")
	name_label.add_theme_color_override("font_color", Color.YELLOW)
	
	var desc_label = Label.new()
	desc_label.text = skill_data.get("description", "")
	desc_label.add_theme_font_size_override("font_size", 10)
	
	vbox.add_child(name_label)
	vbox.add_child(desc_label)
	panel.add_child(vbox)
	
	return panel
