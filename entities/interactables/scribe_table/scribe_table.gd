extends Node3D


@export var on_spell_choosen: Dictionary[Node, StringName]
@export var single_use: bool = true


func _on_interacted() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var menu: Control = UiManager.add_ui_scene("uid://dh8msa1h40vqf")
	menu.tree_exited.connect(_on_menu_tree_exited)


func _on_menu_tree_exited() -> void:
	Globals.spells_changed.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	for node: Node in on_spell_choosen:
		node.call(on_spell_choosen[node])
	if single_use:
		$book_01_sm.hide()
		$Candle/OmniLight3D.hide()
		$Candle/GPUParticles3D.hide()
		$InteractArea3D/CollisionShape3D.disabled = true
