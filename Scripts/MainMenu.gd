extends Control


func _ready():
	if not Music.playing:
		Music.play()


func _on_start_button_pressed():
	Music.stop()
	get_tree().change_scene_to_file("res://Scenes/Telegraph.tscn")


func _on_about_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/AboutScene.tscn")


func _on_volume_changed(new_volume_db):
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_index, new_volume_db)
