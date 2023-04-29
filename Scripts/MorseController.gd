extends Node


@export var dot_duration: float = 0.05
@export var dash_duration: float = 0.1
@export_range(0.005, 0.2) var tolerance: float = 0.05


var is_pressed: bool = false
var pressed_duration: float = 0.0

var inputs: String = ""


func _ready():
	assert(dot_duration < dash_duration)


func _determine_letter(code):
	var letter = MorseUtils.get_letter(code)


func _register_input():
	print("Registering input, elapsed %f" % pressed_duration)
	var input = ''
	if pressed_duration < dot_duration + tolerance / 2:
		input = '.'
	elif pressed_duration < dash_duration + tolerance * 2:
		input = '-'
	
	inputs += input
	print("Registered %s" % input)
	

func _process(delta):
	if Input.is_action_pressed("telegraph_press"):
		if not is_pressed:
			pressed_duration = 0.0
			is_pressed = true
		else:
			pressed_duration += delta
	else:
		if is_pressed:
			pressed_duration += delta
			_register_input()
		is_pressed = false
