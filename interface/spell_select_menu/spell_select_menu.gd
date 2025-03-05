extends Control


@export var spell_list: Array[SpellInfo] = []


func _ready() -> void:
	#%StartRunButton.disabled = true
	pass


func _on_spell_slot_assigned(slot: String, spell: SpellInfo) -> void:
	match slot:
		"primary":
			Globals.choosen_spells["primary"] = spell
		"secondary":
			Globals.choosen_spells["secondary"] = spell


func _on_reroll_button_pressed() -> void:
	%RerollButton.disabled = true


func _on_close_button_pressed() -> void:
	Globals.start_run()
	queue_free()
