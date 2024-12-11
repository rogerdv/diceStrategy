extends Node2D
@onready var timer = $Timer

const lines: Array[String] = [
	"Ciao, questo è un test!",
	"Proviamo così",
	"Vabbè..."
]
const emotions: Array[String] = [
	"happy",
	"sad",
	"angry",
]
var companion
func _ready():
	_add_companions()
	timer.start(5)
	DialogueManager.start_dialog(companion, lines, emotions)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _add_companions() -> void:
	var count = 0
	for x in CharacterManager.characters:
		var new_companion = CharacterManager.characters[x].duplicate()
		print(CharacterManager.characters[x].name)
		companion = new_companion
		new_companion.connect("companion_removed", Callable(self, "_on_companion_removed"))
		add_child(new_companion)
		return
