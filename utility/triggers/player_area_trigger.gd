extends Area3D


signal player_entered()

@export var on_player_entered: Dictionary[Node, StringName]


## If ture, this area will be triggered every time the player enters the area.
## Even if it has allready been triggered before
@export var repeat_trigger: bool = false

var triggered: bool = false


func _on_body_entered(_body: Node3D) -> void:
	if not triggered:
		player_entered.emit()
		for node: Node in on_player_entered:
			node.call(on_player_entered[node])
		if not repeat_trigger:
			triggered = true
