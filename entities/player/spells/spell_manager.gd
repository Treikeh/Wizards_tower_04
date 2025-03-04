extends Node3D


var primary_spell: Spell
var secondary_spell: Spell


func _ready() -> void:
	for spell: String in Globals.selected_spells:
		print(spell)
		match spell:
			"Fireball":
				# Spawn spell
				var fireball_spell: Spell = load("uid://b67g7lxmkqiym").instantiate()
				add_child(fireball_spell)
				# Assign spell
				if not primary_spell:
					primary_spell = fireball_spell
				else:
					secondary_spell = fireball_spell
			"Windblast":
				# Spawn spell
				var windblast_spell: Spell = load("uid://qko6nfg0jk3x").instantiate()
				add_child(windblast_spell)
				# Assign spell
				if not primary_spell:
					primary_spell = windblast_spell
				else:
					secondary_spell = windblast_spell
			"Rockwall":
				# Spawn spell
				var rockwall_spell: Spell = load("uid://di11tekkwb3jv").instantiate()
				add_child(rockwall_spell)
				# Assign spell
				if not primary_spell:
					primary_spell = rockwall_spell
				else:
					secondary_spell = rockwall_spell
			"Lightning Beam":
				# Spawn spell
				var lightning_beam_spell: Spell = load("uid://ctwjw43o46ull").instantiate()
				add_child(lightning_beam_spell)
				# Assign spell
				if not primary_spell:
					primary_spell = lightning_beam_spell
				else:
					secondary_spell = lightning_beam_spell
			_:
				print("empty spell")
				# Spawn spell
				var empty_spell: Spell = Spell.new()
				add_child(empty_spell)
				# Assign spell
				if not primary_spell:
					primary_spell = empty_spell
				else:
					secondary_spell = empty_spell
