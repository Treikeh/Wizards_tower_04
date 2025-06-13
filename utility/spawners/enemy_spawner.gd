extends Node3D
##GOAL: Spawn enemies based on difficulty score. Higher score = more & stronger enemies
#TODO: Give event enemy a score/weight value
#TODO: Make enemies with lower weight less likely to spawn
#TODO: Increase the likleyhood of enemies spawning higher when difficluty increases
#TODO: Add a system that only spawns enemies on 1 out of many spawner (add more variation)
#TODO: Add enemy preferences to spawners

#NOTE: Instead of having a weighted table/array of enemies and randomly choosing 1 of them, i could
# have a "money" value which increases with difficulty, and then give evey enemy a cost. Every time
# the system wants to spawn an enemy it checks the currenly available funds and chooses a random
# enemy that cost less that what is has. This could also be combined with a weight system to allow
# for greater control over when and which enemies spawn. The money value could also be mapped to a
# curve.


@export var enemies: Array[PackedScene] = []
@export var spawn_delay: float = 1.5

var difficulty_score: float = 0.0

@onready var spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	#%Mesh.hide()
	spawn_timer.wait_time = spawn_delay
	spawn_timer.timeout.connect(spawn_scene)


func spawn_scene() -> void:
	var enemy: Node3D = _get_random_enemy().instantiate()
	add_child(enemy)


func _get_random_enemy() -> PackedScene:
	var index: int = randi_range(0, enemies.size() - 1)
	return enemies[index]
