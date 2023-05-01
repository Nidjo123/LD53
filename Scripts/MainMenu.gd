extends Control


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Telegraph.tscn")


func _on_help_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/HelpScene.tscn")


func _on_about_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/AboutScene.tscn")
