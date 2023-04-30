extends Node2D


signal game_paused
signal game_resumed


func _ready():
	$PauseMenu.hide()


func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		set_paused(not get_tree().paused)


func set_paused(paused):
	if get_tree().paused == paused:
		return
	if paused:
		game_paused.emit()
	$PauseMenu.visible = paused
	get_tree().paused = paused
	if not paused:
		game_resumed.emit()


func _on_resume_button_pressed():
	set_paused(false)
