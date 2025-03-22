class_name SpellChoice
extends Area2D


@export var lerp_speed: float = 15.0
var spell_info: SpellInfo

var is_selected: bool = false
var move_position: Vector2

var info_pop_up: Control


func construct(spell: SpellInfo, start_pos: Vector2) -> void:
	move_position = start_pos
	spell_info = spell
	$Sprite2D.texture = spell.icon


func _process(delta: float) -> void:
	if is_selected:
		var mouse_position: Vector2 = get_window().get_mouse_position()
		global_position = lerp(global_position, mouse_position, lerp_speed * delta)
	else:
		global_position = lerp(global_position, move_position, lerp_speed * delta)


func _on_texture_button_button_down() -> void:
	is_selected = true
	if info_pop_up:
		info_pop_up.queue_free()


func _on_texture_button_button_up() -> void:
	is_selected = false


func _on_texture_button_mouse_entered() -> void:
		scale = Vector2(1.1, 1.1)
		if not is_selected:
			info_pop_up = load("uid://bwjxlsiucquc6").instantiate()
			add_child(info_pop_up)
			info_pop_up.construct(spell_info.name, spell_info.description, global_position)
			info_pop_up.z_index = z_index + 1


func _on_texture_button_mouse_exited() -> void:
		scale = Vector2(1.0, 1.0)
		if info_pop_up:
			info_pop_up.queue_free()
