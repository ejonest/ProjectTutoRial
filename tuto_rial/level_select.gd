extends Control

func _on_error_level_pressed():
	get_tree().change_scene_to_file("res://Levels/error_world.tscn")

func _on_enchanted_level_pressed():
	get_tree().change_scene_to_file("res://Levels/ForestScene.tscn")

func _on_maze_level_pressed():
	get_tree().change_scene_to_file("res://Levels/slime_maze.tscn")

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")
