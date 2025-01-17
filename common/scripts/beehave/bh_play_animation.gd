class_name PlayAnimationBH
extends ActionLeaf
## Plays an animation. Doesn't work with animation trees

@export var animation_name: String = ""
@export var animation_player: AnimationPlayer


func tick(actor: Node, _blackboard: Blackboard) -> int:
	# Check if animation exists
	if not animation_player.has_animation(animation_name):
		print("ERROR! \"%s\" is missing \"%s\" animation" % [actor.name, animation_name])
		return FAILURE
	
	animation_player.play(animation_name)
	if animation_player.is_playing():
		return RUNNING
	
	return SUCCESS
