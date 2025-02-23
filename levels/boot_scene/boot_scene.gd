extends Node


#TODO: Add shader compiling to the boot sequence


func _ready() -> void:
	pass


func load_main_menu() -> void:
	LevelManager.change_level("res://levels/main_menu/main_menu.tscn")
