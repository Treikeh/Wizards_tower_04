class_name SpellChoice
extends Area2D


@export var spell_info: SpellInfo
@export var lerp_speed: float = 15.0

var is_selected: bool = false

var spawn_position: Vector2
var slot_positoin: Vector2
var move_to_position: Vector2


func construct() -> void:
	spawn_position = global_position
	move_to_position = spawn_position
	$Sprite2D.texture = spell_info.spell_icon


func _process(delta: float) -> void:
	if is_selected:
		move_to_position = get_window().get_mouse_position()
	elif slot_positoin:
		move_to_position = slot_positoin
	else:
		move_to_position = spawn_position
	
	global_position = lerp(global_position, move_to_position, lerp_speed * delta)


func _on_texture_button_button_down() -> void:
	is_selected = true


func _on_texture_button_button_up() -> void:
	is_selected = false


func _on_texture_button_mouse_entered() -> void:
		scale = Vector2(1.1, 1.1)


func _on_texture_button_mouse_exited() -> void:
		scale = Vector2(1.0, 1.0)
