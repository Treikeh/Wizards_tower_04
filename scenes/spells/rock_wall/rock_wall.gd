extends CharacterBody3D

var is_destroyed: bool = false
var lifetime: float = 10.0

# Explosion
var is_timed_explosion: bool = false
var timed_explosion_duration: float = 5.0
## Minnimum amount of damage needed to trigger explosion
var damage_threshold: float = 10.0
# Wind blast
var wind_blast_force: float = 15.0

@export_group("Nodes")
@export var animation_player: AnimationPlayer

func _ready() -> void:
	# Despawwn wall after duration runs out
	get_tree().create_timer(lifetime).timeout.connect(spell_duration_over)

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if is_on_wall():
		velocity = Vector3.ZERO
	move_and_slide()

# When spell duration ends
func spell_duration_over() -> void:
	wall_destroyed()

#TEMP: Find a better way to do this
func wind_blast(direction: Vector3) -> void:
	velocity = Vector3(direction.x, 0.0, direction.z) * wind_blast_force

#region Health

func _on_hitbox_damage_recived(damage: Damage) -> void:
	match damage.type:
		Damage.Type.FIRE:
			if damage.amount < damage_threshold:
				return
			if !is_timed_explosion:
				is_timed_explosion = true
				get_tree().create_timer(timed_explosion_duration).timeout.connect(explode)
			else:
				explode()

# When wall health is depleted
func wall_destroyed() -> void:
	if is_destroyed:
		return
	is_destroyed = true
	animation_player.play("destroyed")

func explode() -> void:
	if is_destroyed:
		return
	is_destroyed = true
	animation_player.play("explode")

#endregion
