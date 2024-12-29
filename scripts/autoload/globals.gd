extends Node

## Player signals
@warning_ignore("unused_signal")
signal player_died

## UI Signals
@warning_ignore("unused_signal")
signal interact_prompt_updated(prompt: String)
@warning_ignore("unused_signal")
signal health_bar_updated(health: float)


var main_scene: MainScene
