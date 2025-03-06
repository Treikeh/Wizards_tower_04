extends Node3D


var primary_spell: Spell
var secondary_spell: Spell


func _ready() -> void:
	spawn_spells()
	Globals.spells_changed.connect(spawn_spells)


func spawn_spells() -> void:
	for slot: String in Globals.choosen_spells:
		var new_spell: Spell = load(Globals.choosen_spells[slot].spell_scene).instantiate()
		add_child(new_spell)
		match slot:
			"primary":
				primary_spell = new_spell
			"secondary":
				secondary_spell = new_spell


func start_casting_primary_spell() -> void:
	if not primary_spell:
		return
	primary_spell.start_casting()

func stop_casting_primary_spell() -> void:
	if not primary_spell:
		return
	primary_spell.stop_casting()


func start_casting_secondary_spell() -> void:
	if not secondary_spell:
		return
	secondary_spell.start_casting()

func stop_casting_secondary_spell() -> void:
	if not secondary_spell:
		return
	secondary_spell.stop_casting()
