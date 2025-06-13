extends PanelContainer


func construct(spell_name: String, spell_description: String, spawn_pos: Vector2) -> void:
	%SpellNameLabel.text = spell_name
	%SpellDescriptionLabel.text = spell_description
	global_position = spawn_pos
