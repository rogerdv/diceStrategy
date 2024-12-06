extends MarginContainer

@onready var label = $MarginContainer/Label
@onready var timer = $LetterDisplayTimer

const MAX_WIDTH = 256

var letter_index = 0
var letter_timer = 0.03
var space_timer = 0.06
var punctuation_timer = 0.2
signal finished_displaying

var type: int
var from: String
var to: String
var text: String = ""
var emotion: String


func _ready():
	print(label)


func display_text(text_to_display: String):
	text = text_to_display
	label.text = text_to_display
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized #aspettiamo x
		await resized #aspettiamo y
		custom_minimum_size.y = size.y
	global_position.x -= size.x / 2
	global_position.y -= size.y + 54
	
	label.text = ""
	_display_letter()
	
func _display_letter():
	label.text += text[letter_index]
	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		return
	match text[letter_index]:
		"!", "?", ".", ",":
			timer.start(punctuation_timer)
		" ":
			timer.start(space_timer)
		_:
			timer.start(letter_timer)
	


func _on_letter_display_timer_timeout():
	_display_letter()
