extends Control


@export var spell_list: Array[SpellInfo] = []
#HACK: Stops spells from being removed when the menu closes
var eh: bool = false


func _on_start_run_button_pressed() -> void:
	eh = true
	queue_free()


func _on_reroll_button_pressed() -> void:
	%RerollButton.disabled = true


func _on_spell_slot_assigned(slot: String, spell: SpellInfo) -> void:
	Globals.choosen_spells[slot] = spell


func _on_spell_slot_removed(slot: String) -> void:
	if not eh:
		Globals.choosen_spells.erase(slot)
