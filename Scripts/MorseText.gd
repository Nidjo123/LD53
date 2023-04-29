extends Control


var letter_idx = 0
var passed = 0.0


func _ready():
	var font = self.get_theme_font("font")
	print(font.get_font_name())
	print(font.get_font_style_name())
	_set_hint_text()


func get_string_size(string):
	var font = self.get_theme_font("font")
	var font_size = $Text.get_theme_font_size("font_size")
	return font.get_string_size(string, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)


func get_letter_position(letter_index):
	var text = $Text.text
	var text_so_far = text.substr(0, letter_index + 1)
	var text_size = get_string_size(text_so_far)
	text_size.y = 0
	var letter_size = get_string_size(text[letter_index])
	var hint_offset = Vector2(-letter_size.x / 2, -letter_size.y)
	return $Text.position + text_size + hint_offset


func _set_hint_text():
	var letter = $Text.text[letter_idx]
	var hint_text = MorseUtils.get_code(letter)
	$MorseHint/HintText.text = hint_text


func _process(delta):
	var letter_position = get_letter_position(letter_idx)
	$MorseHint.position = letter_position - $MorseHint.size / 2
	$ColorRect.position = letter_position - $ColorRect.size / 2
	passed += delta
	if passed >= 1.0:
		letter_idx = (letter_idx + 1) % 8
		passed -= 1.0
		_set_hint_text()
