#@tool
extends Node3D


func _on_damage_area_hit_health_area(health_area: HealthArea3D) -> void:
	var health_node: Health = health_area.health_node
	#print("Max health: %d, current health %d" % [health_node.max_health, health_node.current_health])
	# Only delte node if health was recived
	if health_node.current_health < health_node.max_health:
		queue_free()
