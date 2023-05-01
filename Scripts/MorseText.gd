extends Control


signal finished(accuracy: float)


@onready var letter_idx = 0
@onready var correct_letters = []
@onready var original_text = $Text.get_parsed_text()


func _ready():
	_set_hint()


func reset(text):
	$Text.text = text
	original_text = text
	letter_idx = 0
	correct_letters.clear()
	_set_hint()


func get_string_size(string):
	var font = self.get_theme_font("font")
	var font_size = $Text.get_theme_font_size("normal_font_size")
	return font.get_string_size(string, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)


func _get_line_start_letter_idx(letter_index):
	assert(original_text[letter_index] != '\n')
	while letter_index > 0 and original_text[letter_index] != '\n':
		letter_index -= 1
	return letter_index + 1 if letter_index > 0 else letter_index


func _get_character_line(letter_index):
	return original_text.substr(0, letter_index).count('\n')


func _get_line_text(letter_index):
	var line_start_idx = _get_line_start_letter_idx(letter_index)
	var len = letter_index - line_start_idx + 1
	return original_text.substr(line_start_idx, len)
	

func _get_letter_position(letter_index):
	var text = original_text
	var line_text = _get_line_text(letter_index)
	var text_size = get_string_size(line_text)
	var letter_size = get_string_size(text[letter_index])
	var line = _get_character_line(letter_index)
	text_size.y = $Text.get_line_offset(line)
	var hint_offset = Vector2(-letter_size.x / 2, -letter_size.y)
	return $Text.position + (text_size + hint_offset) * $Text.scale


func _set_hint():
	var letter = original_text[letter_idx]
	var hint_text: String = MorseUtils.get_code(letter)
	$MorseHint/HintText.text = hint_text
	$MorseHint.show()


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


func _is_skippable(s):
	return MorseUtils.get_code(s) == ''


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
	while letter_idx < text.length() and _is_skippable(text[letter_idx]):
		correct_letters.append(null)
		letter_idx += 1
	if letter_idx >= text.length():
		_finished()
	else:
		_set_hint()
	_set_text()


func _get_accuracy():
	var letter_count = 0
	for letter in original_text:
		if MorseUtils.get_code(letter) != '':
			letter_count += 1
	var correct_count = correct_letters.count(true)
	return float(correct_count) / letter_count * 100


func _finished():
	$MorseHint.hide()
	var accuracy = _get_accuracy()
	finished.emit(accuracy)


func _process(_delta):
	if letter_idx < original_text.length():
		var letter_position = _get_letter_position(letter_idx)
		$MorseHint.position = letter_position - $MorseHint.size / 2
