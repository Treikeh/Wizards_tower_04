extends Node3D


var primary_spell: Spell
var secondary_spell: Spell


func _ready() -> void:
	spawn_spells()


func spawn_spells() -> void:
	for slot: String in Globals.choosen_spells:
		var new_spell: Spell = load(Globals.choosen_spells[slot].spell_scene).instantiate()
		add_child(new_spell)
		match slot:
			"primary":
				primary_spell = new_spell
			"secondary":
				secondary_spell = new_spell
