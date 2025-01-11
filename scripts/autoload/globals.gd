extends Node


## Player
@warning_ignore("unused_signal")
signal player_died

var player_health: float = 1.0


## UI
@warning_ignore("unused_signal")
signal interact_prompt_updated(prompt: String)
@warning_ignore("unused_signal")
signal health_bar_updated(health: float)
@warning_ignore("unused_signal")
signal player_casted_spell(id: int, spell_cooldown: float)


var main_scene: MainScene
