extends Node2D


signal game_paused
signal game_resumed


@onready var time_spent: float = 0.0
@onready var current_level: int = 0

@export_multiline var level_texts: Array[String] = []


func _is_level_transition():
	return $EndMenu.visible


func _ready():
	$Game/MorseText.hide()
	$Game/PaperAnimation.hide()
	$Game/PaperAnimation.frame = 0
	$PauseMenu.hide()
	$EndMenu.hide()
	$GameIntro.show()


func _process(delta):
	var is_level_transition = _is_level_transition()
	if Input.is_action_just_pressed("ui_cancel") and not is_level_transition:
		set_paused(not get_tree().paused)
		
	if not get_tree().paused and not is_level_transition:
		time_spent += delta


func set_paused(paused):
	if get_tree().paused == paused or _is_level_transition():
		return
	if paused:
		game_paused.emit()
	$PauseMenu.visible = paused
	get_tree().paused = paused
	if not paused:
		game_resumed.emit()


func _on_resume_button_pressed():
	set_paused(false)


func _on_morse_text_finished(accuracy):
	set_paused(false)
	$EndMenu.set_accuracy(accuracy)
	$EndMenu.set_time(time_spent)
	$EndMenu.show()


func _get_text():
	return level_texts[current_level]


func _on_level_start():
	$Game/MorseText.hide()
	$Game/PaperAnimation.show()
	$Game/PaperAnimation.frame = 0
	$Game/PaperAnimation.play()


func _on_play_button_pressed():
	$GameIntro.hide()
	_on_level_start()


func _on_intro_animation_finished():
	time_spent = 0
	var text = _get_text()
	$Game/MorseText.reset(text)
	$Game/MorseText.show()
