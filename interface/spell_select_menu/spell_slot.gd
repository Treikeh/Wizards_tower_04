extends Node2D

signal slot_assigned(slot: String, spell: SpellInfo)


@export_enum("primary", "secondary") var slot: String = "primary"


func _ready() -> void:
		$SlotLabel.text = slot


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is SpellChoice:
		area.slot_positoin = global_position
		$SlotLabel.text = area.spell_info.spell_name
		slot_assigned.emit(slot, area.spell_info)


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area is SpellChoice:
		area.slot_positoin = Vector2.ZERO
		$SlotLabel.text = slot
