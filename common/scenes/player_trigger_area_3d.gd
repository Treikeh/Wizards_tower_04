extends Area3D


signal player_entered()


## If ture, this area will be triggered every time the player enters the area.
## Even if it has allready been triggered before
@export var repeat_trigger: bool = false

var triggered: bool = false


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and (not triggered):
		player_entered.emit()
		if not repeat_trigger:
			triggered = true
