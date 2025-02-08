extends Area3D


var activated: bool = false


func _ready() -> void:
	$Mesh.hide()


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and not activated:
		activated = true
		Globals.is_checkpoint_active = true
		Globals.checkpoint_saved.emit()
		Globals.checkpoint_transform = global_transform
