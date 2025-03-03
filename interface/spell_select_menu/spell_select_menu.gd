extends Control


@export var spell_list: Array[String] = []


func _ready() -> void:
	$CloseButton.hide()
	for button: Button in %SpellButtonsContainer.get_children():
		var spell_index: int = randi_range(0, spell_list.size() - 1)
		button.text = spell_list[spell_index]
		button.pressed.connect(_on_spell_button_pressed.bind(button.text))
		spell_list.pop_at(spell_index)


func _on_spell_button_pressed(text: String) -> void:
	if %SpellLabel1.text == "":
		%SpellLabel1.text = text
	elif %SpellLabel2.text == "":
		%SpellLabel2.text = text
		$CloseButton.show()


func _on_reroll_button_pressed() -> void:
	var new_scene: Control = load("uid://dh8msa1h40vqf").instantiate()
	get_tree().root.add_child(new_scene)
	queue_free()


func _on_close_button_pressed() -> void:
	queue_free()
