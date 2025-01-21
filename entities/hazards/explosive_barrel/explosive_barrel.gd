extends Node3D


@export_group("Nodes")
@export var explosion_area: Area3D
@export var health_area: HealthArea3D
@export var explosion_delay: Timer


func _on_health_health_depleted() -> void:
	# A small delay before the barrel explodes to avoid having every barrel in its radius explode ->
	# <- at the same time
	explosion_delay.start(0.0)


func _on_explosion_delay_timeout() -> void:
	explosion_area.trigger()
	queue_free()
