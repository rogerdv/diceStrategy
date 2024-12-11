extends Node

@onready var text_box_scene = preload("res://dialogue/dialogue.tscn")

enum dialogue_type {
	RANDOM,
	DEATH,
	ON_ACTION,
	AFTER_EVENT,
	SPECIAL
}

@export var dialogues = {
	dialogue_type.ON_ACTION : {
		"lloyd": [
			"I'm on it, boss!",
			"Sure!",
			"Glad to be of help!",
			"Let's get it done!",
			"Consider it done, boss!",
			"On my way, boss!",
			"Right away!",
			"No problem at all!",
			"I've got this!",
	  ]
	}
}

var dialog_lines : Array[String] = []
var emotions_list : Array = []
var current_line_index = 0
var text_box
var text_box_position: Vector2
var character

var is_dialog_active = false
var can_advance_line = false

func start_dialog(_character, lines: Array[String], _emotions_list):
	if is_dialog_active:
		return
	dialog_lines = lines
	emotions_list = _emotions_list
	text_box_position = _character.global_position
	character = _character
	_show_text_box()
	
	is_dialog_active = true

func _show_text_box():
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	text_box.get_children()[1].get_children()[0].text = "test"
	#print(text_box.get_children()[1].get_children()[0].text )
	get_tree().root.call_deferred("add_child", text_box)
	text_box.global_position = text_box_position
	text_box.call_deferred("display_text", dialog_lines[current_line_index])
	character._set_emotion(emotions_list[current_line_index])
	can_advance_line = false
	
func _on_text_box_finished_displaying():
	can_advance_line = true
	await get_tree().create_timer(1.0).timeout
	text_box.queue_free()
	current_line_index += 1
	if current_line_index >= dialog_lines.size():
		is_dialog_active = false
		current_line_index = 0
		return
	_show_text_box()

