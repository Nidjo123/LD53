extends Node


# see https://en.wikipedia.org/wiki/Morse_code


var _mapping = {
	'A': '.-',
	'B': '-...',
	'C': '-.-.',
	'D': '-..',
	'E': '.',
	'F': '..-.',
	'G': '--.',
	'H': '....',
	'I': '..',
	'J': '.---',
	'K': '-.-',
	'L': '.-..',
	'M': '--',
	'N': '-.',
	'O': '---',
	'P': '.--.',
	'Q': '--.-',
	'R': '.-.',
	'S': '...',
	'T': '-',
	'U': '..-',
	'V': '...-',
	'W': '.--',
	'X': '-..-',
	'Y': '-.--',
	'Z': '--..',
	
	'1': '.----',
	'2': '..---',
	'3': '...--',
	'4': '....-',
	'5': '.....',
	'6': '-....',
	'7': '--...',
	'8': '---..',
	'9': '----.',
	'0': '-----'
}

var _inv_mapping = {}


func get_code(letter: String):
	return _mapping.get(letter.to_upper(), '')
	
	
func has_code(code: String):
	return code in _inv_mapping


func get_letter(code):
	return _inv_mapping.get(code, '')


func _ready():
	for letter in _mapping:
		var code = _mapping[letter]
		_inv_mapping[code] = letter
