extends Node2D


signal slot_assigned(slot: String, spell: SpellInfo)
signal slot_removed(slot: String)


@export_enum("primary", "secondary") var slot: String = "primary"
var spell_choice: SpellChoice


func _ready() -> void:
		$SlotLabel.text = slot
		if Globals.choosen_spells.has(slot):
			# Spawn spell choice
			pass


func _on_area_entered(area: Area2D) -> void:
	if area is SpellChoice:
		# Remove old spell choice
		if spell_choice != null:
			spell_choice.slot_positoin = Vector2.ZERO
		
		spell_choice = area
		spell_choice.slot_positoin = global_position
		slot_assigned.emit(slot, spell_choice.spell_info)
		#$SlotLabel.text = spell_choice.spell_info.spell_name


func _on_area_exited(area: Area2D) -> void:
	if area == spell_choice:
		spell_choice.slot_positoin = Vector2.ZERO
		# Clear spell choice
		spell_choice = null
		#$SlotLabel.text = slot
		# This gets emitted when the scene (or parrent scen) gets removed and i don't want it to happen
		slot_removed.emit(slot)
