extends CharacterBody3D

@export var wind_blast_force: float = 7.5
## How long the rock wall will be in the scene before despawning
@export var lifetime: float = 10.0
@export var explosion_damage: Damage

# Explosion
var is_timed_explosion: bool = false
var timed_explosion_duration: float = 5.0
## Minnimum amount of damage needed to trigger explosion
var damage_threshold: float = 10.0


func _ready() -> void:
	# Despawwn wall after duration runs out
	get_tree().create_timer(lifetime).timeout.connect(spell_duration_over)


@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if is_on_wall() or !is_on_floor():
		velocity = Vector3.ZERO
	move_and_slide()


# When spell duration ends
func spell_duration_over() -> void:
	_on_health_depleted()


#TODO: Find a better way to do this
func recive_knockback(direction: Vector3) -> void:
	velocity = Vector3(direction.x, 0.0, direction.z).normalized() * wind_blast_force
	is_timed_explosion = true
	# Add damage to movement


func _explode() -> void:
	%AnimationPlayer.play("explode")


#TODO: Find a better name for function
func deal_explosion_damage() -> void:
	# Explosion damage
	var damaged_health_nodes: Array[Health] = []
	var overlapping_areas: Array[Area3D] = %ExplosionArea.get_overlapping_areas()
	for area in overlapping_areas:
		if area is HealthArea3D:
			# Check if the health_node of the hurtbox has allready been hit
			if damaged_health_nodes.has(area.health_node):
				return
			#TODO: Line of sight check
			#TODO: Scale damage based on distance form center
			var duped_damage: Damage = explosion_damage.duplicate()
			area.recive_damage(duped_damage)
			damaged_health_nodes.append(area.health_node)


#region Health

# When wall health is depleted
func _on_health_depleted() -> void:
	%AnimationPlayer.play("destroyed")


func _on_health_area_damage_recived(damage: Damage) -> void:
	match damage.type:
		Damage.Type.FIRE:
			if damage.amount < damage_threshold:
				return
			if !is_timed_explosion:
				is_timed_explosion = true
				get_tree().create_timer(timed_explosion_duration).timeout.connect(_explode)
			else:
				_explode()

#endregion
