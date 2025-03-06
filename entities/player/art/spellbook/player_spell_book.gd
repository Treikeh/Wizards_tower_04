extends Node3D


@export_group(" ")
@export var primary_spell_sprite: Sprite3D
@export var secondary_spell_sprite: Sprite3D


func _ready() -> void:
	Globals.spells_changed.connect(_update_sprites)
	if not Globals.choosen_spells.is_empty():
		_update_sprites()


func _update_sprites() -> void:
	primary_spell_sprite.texture = Globals.choosen_spells["primary"].icon
	secondary_spell_sprite.texture = Globals.choosen_spells["secondary"].icon
