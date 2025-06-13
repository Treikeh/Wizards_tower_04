extends Node
@warning_ignore_start("unused_signal")

#region UI

signal interact_prompt_updated(prompt: String)
signal health_updated(current: float, max: float)
signal notification_sent(message: String)

#endregion


#region Player

signal player_died
signal spells_changed(info: Dictionary[String, SpellInfo])

#endregion
