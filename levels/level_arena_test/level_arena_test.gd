extends Level3D
#NOTE: This is not about this script, i just want to write it down somewhere i will see it later
# I want a spawning system that randomnly spawns enemies and the longer the game is played
# the more likely stronger enemies are to spawn, similar to Risk of Rain 2. I also want to be able
# to spawn enemies at fixed poins in the different levels, but which points are choosen should be
# random. Ceartin spawn points should have different preferences for what type of enemies can spawn
# there. A spawn point on the roof should prefer to spawn ranged enemies for example. The system
# should also not be too repetitive. Enemies shouldn't spawn at the same spawn point all the time
# they should spawn across the entire level. There also shouldn't be too many of the same enemy
# spawning at the same time.


const STARTING_DIFFICULTY: float = 1.0

@export var difficulty_growth: float = 1.0

var current_difficulty: float = 1.0
var level_duration: float = 0.0

@onready var enemy_spawner: Node3D = $EnemySpawner


func _process(delta: float) -> void:
	level_duration += delta
	%DurationLabel.text = "Level duration: %s" % [snappedf(level_duration, 0.1)]
	%DifficultyLabel.text = "Difficulty score: %s" % [current_difficulty]


func _physics_process(delta: float) -> void:
	current_difficulty += difficulty_growth * delta
