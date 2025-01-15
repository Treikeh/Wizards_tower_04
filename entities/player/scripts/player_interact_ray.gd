extends RayCast3D

var interact_target: InteractArea3D

func _process(_delta: float) -> void:
	var target: InteractArea3D
	var prompt: String = ""
	# Check for interactable
	if is_colliding():
		var collider: Object = get_collider()
		if collider is InteractArea3D:
			target = collider
			prompt = collider.prompt + "\n[E]"
	interact_target = target
	Globals.interact_prompt_updated.emit(prompt)

func interact_with_target() -> void:
	if interact_target:
		interact_target.interact()
