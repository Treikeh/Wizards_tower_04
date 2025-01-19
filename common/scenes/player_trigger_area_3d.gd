extends Area3D


signal player_entered()


## If ture, this area will be triggered every time the player enters the area.
## Even if it has allready been triggered before
@export var repeat_trigger: bool = false

var allready_triggered: bool = false


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and (not allready_triggered):
		player_entered.emit()
		if not repeat_trigger:
			allready_triggered = true
