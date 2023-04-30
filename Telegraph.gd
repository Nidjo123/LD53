extends Node2D


func _ready():
	pass


func _process(delta):
	pass


func _on_morse_controller_telegraph_pressed():
	$TelegraphAnimation.play("press")


func _on_morse_controller_telegraph_released():
	$TelegraphAnimation.play_backwards("press")


func _on_telegraph_animation_animation_finished():
	if $TelegraphAnimation.frame == 0:
		$TelegraphAnimation.play("idle")
	else:
		$TelegraphAnimation.pause()


func _on_morse_controller_letter_typed(letter):
	$MorseText.advance_letter(letter)
