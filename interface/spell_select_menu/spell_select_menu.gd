extends Control


@export var spell_list: Array[SpellInfo] = []
#HACK: Stops spells from being removed when the menu closes
var eh: bool = false


func _ready() -> void:
	var temp_list: Array[SpellInfo] = spell_list.duplicate()
	for child: Node2D in $Node2D.get_children():
		if child is SpellChoice:
			var spell_index: int = randi_range(0, temp_list.size() - 1)
			child.spell_info = temp_list[spell_index]
			child.construct()
			temp_list.pop_at(spell_index)


func _on_start_run_button_pressed() -> void:
	eh = true
	queue_free()


func _on_reroll_button_pressed() -> void:
	%RerollButton.disabled = true
	_ready()


func _on_spell_slot_assigned(slot: String, spell: SpellInfo) -> void:
	Globals.choosen_spells[slot] = spell


func _on_spell_slot_removed(slot: String) -> void:
	if not eh:
		Globals.choosen_spells.erase(slot)
