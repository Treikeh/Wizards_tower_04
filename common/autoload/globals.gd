extends Node
@warning_ignore_start("unused_signal")


## Loads data from a csv file into a JSON like format where every row becomes a dict.
## The first colum becomes the key to the the row dict and every other colum becomes a smaler dict within.
## The output is very similar to the "Hash" output from [url]https://csvjson.com/csv2json[/url]
func load_data_from_csv(file_path: String) -> Dictionary[String, Dictionary]:
	var dict: Dictionary[String, Dictionary] = {}
	var file := FileAccess.open(file_path, FileAccess.READ)
	
	# Get all columns categories
	var columns := Array(file.get_csv_line())
	
	# Go through every row and add the data to the dict
	while not file.eof_reached():
		# Get data on current row
		var data_set := Array(file.get_csv_line())
		
		# Convert data from an array to dict with colum as key
		var value_dict: Dictionary = {}
		# Start at the "2" array spot to avoid adding the row key to the value dict
		for i: int in range(1, columns.size()):
			value_dict[columns[i]] = data_set[i]
		
		# Add data to dict with the first colum value as key
		dict[data_set[0]] = value_dict
	
	file.close()
	return dict


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

var level_list: Array[String] = [
	"uid://bcqlh303l8l7r",
	"uid://n1x6gqci2ata",
	"uid://bbc3cusxgyev0",
	"uid://ivqogohs83mj",
	"uid://cn536mfnvbgrk",
	]


func load_random_level() -> void:
	var level_index: int = randi_range(0, level_list.size() - 1)
	LevelManager.change_level(level_list[level_index])


func start_run() -> void:
	run_in_progress = true
	run_started.emit()


func reset_run_info() -> void:
	run_in_progress = false
	run_duration = 0.0
	rooms_cleared = 0
	enemies_killed = 0
	choosen_spells.clear()

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
