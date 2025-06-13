extends Node3D


@export var primary_spell: SpellInfo
@export var secondary_spell: SpellInfo


func _ready() -> void:
	Globals.reset_run_info()


func start_run() -> void:
	_on_play_trigger_entered()


func _on_play_trigger_entered() -> void:
	Globals.load_random_level()
	Globals.start_run()


func _on_spell_table_interacted() -> void:
	Globals.choosen_spells["primary"] = primary_spell
	Globals.choosen_spells["secondary"] = secondary_spell
	Globals.spells_changed.emit()
	# Feedback
	$SpellTable/book_01_sm.hide()
	$SpellTable/Candle/OmniLight3D.hide()
	$SpellTable/Candle/GPUParticles3D.emitting = false
	$SpellTable/InteractArea3D/CollisionShape3D.disabled = true
