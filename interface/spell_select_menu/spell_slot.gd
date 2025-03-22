extends Node2D


signal slot_assigned(slot: String, spell: SpellInfo)


@export_enum("primary", "secondary") var slot: String = "primary"
var current_choice: SpellChoice


func _ready() -> void:
		$SlotLabel.text = slot
		if Globals.choosen_spells.has(slot):
			var new_choice: SpellChoice = load("uid://bdge64wpp6tfj").instantiate()
			add_child(new_choice)
			new_choice.construct(Globals.choosen_spells[slot], global_position)
			current_choice = new_choice


func _on_area_entered(area: Area2D) -> void:
	if area is SpellChoice:
		# Remove old spell choice
		if current_choice != null:
			current_choice.move_position = area.move_position
		
		current_choice = area
		current_choice.move_position = global_position
		slot_assigned.emit(slot, current_choice.spell_info)


func _on_area_exited(area: Area2D) -> void:
	if area == current_choice:
		current_choice = null
