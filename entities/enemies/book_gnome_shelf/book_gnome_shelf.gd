extends Enemy


var book_gnome_scene: String = "uid://uvws4xru1kpl"


func attack() -> void:
	# Spawn book gnome
	pass



#region Health

func _on_health_depleted() -> void:
	# Disable AI tree and stop movement
	beehave_tree.disable()
	movement_enabled = false
	
	# Play death animation
	%AnimationPlayer.play("died")

#endregion
