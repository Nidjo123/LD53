extends Node2D


signal game_paused
signal game_resumed


enum TimeOfDay { DAY, NIGHT }


@onready var time_spent: float = 0.0
@export var current_level: int = 0

@export_multiline var level_texts: Array[String] = []
@export var time_of_day: Array[TimeOfDay] = []
@export var day_texture: Texture2D = load("res://Images/tbg-day.png")
@export var night_texture: Texture2D = load("res://Images/tbg-night.png")


func _is_level_transition():
	return $EndMenu.visible
	
	
func _is_intro_shown():
	return $GameIntro.visible


func _ready():
	assert(level_texts.size() == time_of_day.size())
	$Game/MorseText.hide()
	$Game/PaperAnimation.hide()
	$Game/PaperAnimation.frame = 0
	$PauseMenu.hide()
	$EndMenu.hide()
	$GameIntro.show()
	_prepare_background()


func _process(delta):
	var is_level_transition = _is_level_transition()
	if Input.is_action_just_pressed("ui_cancel") and not is_level_transition:
		set_paused(not get_tree().paused)
		
	if not get_tree().paused and not is_level_transition:
		time_spent += delta


func set_paused(paused):
	if get_tree().paused == paused or _is_level_transition() or _is_intro_shown():
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
	

func _get_time_of_day():
	return time_of_day[current_level]


func _prepare_background():
	match _get_time_of_day():
		TimeOfDay.DAY:
			$Game/Background.texture = day_texture
			$Game/Background/DeskLight.hide()
		TimeOfDay.NIGHT:
			$Game/Background.texture = night_texture
			$Game/Background/DeskLight.show()


func _on_level_start():
	_prepare_background()
	$Game/MorseText.hide()
	$Game/PaperAnimation.show()
	$Game/PaperAnimation.frame = 0
	$Game/PaperAnimation.play()
	$Game/TelegraphAnimation.play("idle")


func _on_play_button_pressed():
	$GameIntro.hide()
	_on_level_start()


func _on_intro_animation_finished():
	time_spent = 0
	var text = _get_text()
	$Game/MorseText.reset(text)
	$Game/MorseText.show()


func _on_next_level():
	if $Game/MorseText.get_accuracy() >= 60:
		current_level += 1
	var num_levels = level_texts.size()
	if current_level == num_levels - 1:
		Music.set_stream(Music.intense_theme)
		Music.play()
	if current_level >= level_texts.size():
		Music.stop()
		get_tree().change_scene_to_file("res://Scenes/EndScene.tscn")
	else:
		$EndMenu.hide()
		_on_level_start()
