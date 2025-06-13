extends Control


@export var spell_list: Array[SpellInfo] = []
var spells_selected: int = 0


func _ready() -> void:
	%StartRunButton.disabled = true
	randomize_spell_choices()


func randomize_spell_choices() -> void:
	var temp_list: Array[SpellInfo] = spell_list.duplicate()
	for child: Node2D in $Node2D.get_children():
		if child is SpellChoice:
			var spell_index: int = randi_range(0, temp_list.size() - 1)
			child.construct(temp_list[spell_index], child.global_position)
			temp_list.pop_at(spell_index)


func _on_start_run_button_pressed() -> void:
	queue_free()


func _on_reroll_button_pressed() -> void:
	%RerollButton.disabled = true
	randomize_spell_choices()


func _on_spell_slot_assigned(slot: String, spell: SpellInfo) -> void:
	Globals.choosen_spells[slot] = spell
	spells_selected += 1
	if spells_selected >= 2:
		%StartRunButton.disabled = false
