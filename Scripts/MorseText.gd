extends Control


signal finished(accuracy: float)


@onready var letter_idx = 0
@onready var correct_letters = []
@onready var original_text = $Text.text


func _ready():
	var font = self.get_theme_font("font")
	print(font.get_font_name())
	print(font.get_font_style_name())
	_set_hint_text()


func get_string_size(string):
	var font = self.get_theme_font("font")
	var font_size = $Text.get_theme_font_size("normal_font_size")
	return font.get_string_size(string, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)


func get_letter_position(letter_index):
	var text = original_text
	var text_so_far = text.substr(0, letter_index + 1)
	var text_size = get_string_size(text_so_far)
	text_size.y = 0
	var letter_size = get_string_size(text[letter_index])
	var hint_offset = Vector2(-letter_size.x / 2, -letter_size.y)
	return $Text.position + (text_size + hint_offset) * $Text.scale


func _set_hint_text():
	var letter = original_text[letter_idx]
	var hint_text: String = MorseUtils.get_code(letter)
	hint_text = hint_text.replace('.', '*')
	$MorseHint/HintText.text = '[center]%s[/center]' % hint_text


func _get_letter_bbcode(letter, correct):
	match correct:
		true:
			return '[color=green]%s[/color]' % letter
		false:
			return '[color=red]%s[/color]' % letter
		null:
			return letter


func _set_text():
	var text = ''
	for i in range(original_text.length()):
		var letter = original_text[i]
		if i < correct_letters.size():
			var correct = correct_letters[i]
			var bbcode = _get_letter_bbcode(letter, correct)
			text += bbcode
		else:
			text += letter
	$Text.text = text
		

func advance_letter(letter: String):
	var text = original_text
	if letter_idx >= text.length():
		return
	var expected_letter = text[letter_idx]
	if letter == '' or letter.nocasecmp_to(expected_letter) != 0:
		correct_letters.append(false)
	else:
		correct_letters.append(true)
	letter_idx += 1
	while letter_idx < text.length() and text[letter_idx] == ' ':
		correct_letters.append(null)
		letter_idx = (letter_idx + 1) % original_text.length()
	if letter_idx >= text.length():
		_finished()
	else:
		_set_hint_text()
	_set_text()


func _get_accuracy():
	var letter_count = 0
	for letter in original_text:
		if MorseUtils.get_code(letter) != '':
			letter_count += 1
	var correct_count = correct_letters.count(true)
	return float(correct_count) / letter_count
	$Text.get_character_line()


func _finished():
	var accuracy = _get_accuracy()
	finished.emit(accuracy)
	$MorseHint/HintText.hide()


func _process(_delta):
	if letter_idx < original_text.length():
		var letter_position = get_letter_position(letter_idx)
		$MorseHint.position = letter_position - $MorseHint.size / 2
