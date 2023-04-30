extends Node


signal telegraph_pressed
signal telegraph_released
signal letter_typed(letter: String)


@export var dot_duration: float = 0.05
@export var dash_duration: float = 0.1
@export var idle_duration: float = 0.5
@export_range(0.005, 0.2) var tolerance: float = 0.05


var is_pressed: bool = false
var pressed_elapsed: float = 0.0
var idle_elapsed: float = 0.0
var inputs: String = ''


func _ready():
	assert(dot_duration < dash_duration)


func _register_input():
	var input = ''
	if pressed_elapsed < dot_duration + tolerance / 2:
		input = '.'
	elif pressed_elapsed < dash_duration + tolerance * 2:
		input = '-'
	
	inputs += input
	if input == '':
		input = 'nothing'
	print("Registered %s, elapsed %f" % [input, pressed_elapsed])


func _process(delta):
	if is_pressed:
		pressed_elapsed += delta
	else:
		idle_elapsed += delta

	if Input.is_action_pressed("telegraph_press"):
		if not is_pressed:
			telegraph_pressed.emit()
	elif is_pressed:
		telegraph_released.emit()
	elif idle_elapsed >= idle_duration and inputs.length() > 0:
		var letter = MorseUtils.get_letter(inputs)
		letter_typed.emit(letter)
		idle_elapsed = 0
		inputs = ''


func _on_telegraph_pressed():
	is_pressed = true
	pressed_elapsed = 0


func _on_telegraph_released():
	_register_input()
	is_pressed = false
	idle_elapsed = 0


func _reset_state():
	is_pressed = false
	idle_elapsed = 0
	pressed_elapsed = 0
	$MorseAudio.stream_paused = true
