extends Node


## Player
@warning_ignore("unused_signal")
signal player_died

#NOTE: Not the best way to manage what spells are unlocked, but it works
var fireball_unlocked: bool = true
var rock_wall_unlocked: bool = true
var wind_blast_unlocked: bool = true
var lightning_ray_unlocked: bool = true


## Hud
@warning_ignore("unused_signal")
signal interact_prompt_updated(prompt: String)

@warning_ignore("unused_signal")
signal health_bar_updated(health: float)

@warning_ignore("unused_signal")
signal spell_casts_updated(spell: int)

@warning_ignore("unused_signal")
signal spell_unlocked(spell: int)

@warning_ignore("unused_signal")
signal spell_recharge_started(id: int)

@warning_ignore("unused_signal")
signal spell_recharge_ended(spell: int)

@warning_ignore("unused_signal")
signal update_lightning_ray_icon(value: float)

@warning_ignore("unused_signal")
signal player_casted_spell(id: int,)

@warning_ignore("unused_signal")
signal notification_message_sent(message: String)


## System
@warning_ignore("unused_signal")
signal checkpoint_saved

@warning_ignore("unused_signal")
signal checkpoint_loaded


var checkpoint_id: int = 0


func quit_game() -> void:
	get_tree().quit()
