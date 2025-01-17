class_name Level3D
extends Node3D


@export_group("Starting spells")
@export var fireball_unlocked: bool = true
@export var rock_wall_unlocked: bool = true
@export var wind_blast_unlocked: bool = true


func _ready() -> void:
	Globals.fireball_unlocked = fireball_unlocked
	Globals.rock_wall_unlocked = rock_wall_unlocked
	Globals.wind_blast_unlocked = wind_blast_unlocked
