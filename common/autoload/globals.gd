extends Node


## Player
@warning_ignore("unused_signal")
signal player_died

#NOTE: Not the best way to manage what spells are unlocked, but it works
var fireball_unlocked: bool = true
var rock_wall_unlocked: bool = true
var wind_blast_unlocked: bool = true


## Hud
@warning_ignore("unused_signal")
signal interact_prompt_updated(prompt: String)

@warning_ignore("unused_signal")
signal health_bar_updated(health: float)

@warning_ignore("unused_signal")
signal spell_unlocked(spell: int)

@warning_ignore("unused_signal")
signal player_casted_spell(id: int, spell_cooldown: float)

@warning_ignore("unused_signal")
signal notification_message_sent(message: String)


## System
@warning_ignore("unused_signal")
signal checkpoint_saved

@warning_ignore("unused_signal")
signal checkpoint_loaded

var is_checkpoint_active: bool = false
var checkpoint_transform: Transform3D


@onready var main_scene: MainScene = get_tree().current_scene
