extends Node3D


@export_group(" ")
@export var primary_spell_sprite: Sprite3D
@export var secondary_spell_sprite: Sprite3D


func _ready() -> void:
	Globals.spells_changed.connect(_update_sprites)
	_update_sprites()


func _update_sprites() -> void:
	if Globals.choosen_spells.has("primary"):
		primary_spell_sprite.texture = Globals.choosen_spells["primary"].icon
	if Globals.choosen_spells.has("secondary"):
		secondary_spell_sprite.texture = Globals.choosen_spells["secondary"].icon
