extends Control


signal game_continued


func set_accuracy(accuracy):
	var label = $CenterContainer/Panel/VBoxContainer/AccuracyHBoxContainer/AccuracyValue
	label.text = '%.2f %%' % accuracy
	
	if accuracy < 60:
		$CenterContainer/Panel/VBoxContainer/ContinueButton.text = 'Retry'
	else:
		$CenterContainer/Panel/VBoxContainer/ContinueButton.text = 'Continue'


func set_time(time):
	var label = $CenterContainer/Panel/VBoxContainer/TimeHBoxContainer/TimeValue
	label.text = '%.2f seconds' % time


func _on_continue_button_pressed():
	game_continued.emit()
