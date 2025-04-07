extends Node
@warning_ignore_start("unused_signal")


func _ready() -> void:
	unplayed_levels = LEVELS.duplicate()


func _process(delta: float) -> void:
	if run_in_progress:
		run_duration += delta


## Player
signal player_died
#NOTE: I don't like doing this, so i need to find a better way at some point
signal spells_changed

var player_health: float = 100.0
var choosen_spells: Dictionary[String, SpellInfo]

#NOTE: I also don't like this
func reset_player() -> void:
	player_health = 100.0


#region Run Info

signal run_started

var run_in_progress: bool = false
var run_duration: float = 0.0
var rooms_cleared: int = 0
var enemies_killed: int = 0


const LEVELS: Array[String] = [
	"uid://bcqlh303l8l7r",
	"uid://n1x6gqci2ata",
	"uid://bbc3cusxgyev0",
	"uid://ivqogohs83mj",
	"uid://cn536mfnvbgrk",
]

var unplayed_levels: Array[String] = []
var previous_level: String = ""


func load_next_level() -> void:
	match rooms_cleared:
		2: # Spawn "shop" room when 2 rooms are cleared
			LevelManager.change_level("uid://d0wdststpnqjf")
		5: # Spawn boss room when 2 rooms after the shop room are cleared.
			# It's 5 since the shop room counts as a level which gets counted as a cleared level
			LevelManager.change_level("uid://bghof87ud2kxr")
		_: # Load random level when not loading other levels
			var level: String = _get_random_level()
			if level == previous_level:
				level = _get_random_level()
			previous_level = level
			LevelManager.change_level(level)


func _get_random_level() -> String:
	var index: int = randi_range(0, unplayed_levels.size() - 1)
	var level: String = unplayed_levels[index]
	# Remove level from list
	unplayed_levels.pop_at(index)
	return level


func start_run() -> void:
	run_in_progress = true
	run_started.emit()


func reset_run_info() -> void:
	run_in_progress = false
	run_duration = 0.0
	rooms_cleared = 0
	enemies_killed = 0
	choosen_spells.clear()
	unplayed_levels = LEVELS.duplicate()

#endregion


#region HUD

signal interact_prompt_updated(prompt: String)
func update_interact_prompt(prompt: String) -> void:
	interact_prompt_updated.emit(prompt)


signal health_bar_updated(health: float)
func update_health_bar(health: float) -> void:
	health_bar_updated.emit(health)


signal notification_message_sent(message: String)
func update_notification_message(message: String) -> void:
	notification_message_sent.emit(message)

#endregion


func quit_game() -> void:
	get_tree().quit()
