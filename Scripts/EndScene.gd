extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Music.set_stream(Music.end_theme)
	Music.play()
	

func _on_main_menu_button_pressed():
	Music.stop()
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
