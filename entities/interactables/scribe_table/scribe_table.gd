extends Node3D


signal spells_choosen


@export var single_use: bool = true


func _on_interact_area_3d_interacted() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var menu: Control = UiManager.add_ui_scene("uid://dh8msa1h40vqf")
	menu.tree_exited.connect(_on_menu_tree_exited)


func _on_menu_tree_exited() -> void:
	Globals.spells_changed.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	spells_choosen.emit()
	if single_use:
		$book_01_sm.hide()
		$Candle/OmniLight3D.hide()
		$Candle/GPUParticles3D.hide()
		$InteractArea3D.queue_free()
