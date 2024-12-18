extends Node

#region System
@warning_ignore("unused_signal")
signal load_level(path: String)
@warning_ignore("unused_signal")
signal quit_game
@warning_ignore("unused_signal")
signal player_died

#endregion


#region UI

@warning_ignore("unused_signal")
signal update_interact_prompt(prompt: String)
@warning_ignore("unused_signal")
signal update_health_bar(value: float)

#endregion
