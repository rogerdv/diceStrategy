extends Node2D

# Constants for Resource Paths
const DiceScenePath: String = "res://scenes/all_dice/dice.tscn"
const DiceRestSquareScenePath: String = "res://scenes/all_dice/dice_rest_square.tscn"
const testDialogPath: String = "res://scenes/event_dialog.tscn"

# Preloaded Scenes
var dice_scene = preload(DiceScenePath)
var dice_rest_square_scene = preload(DiceRestSquareScenePath)
var test_dialog = preload(testDialogPath)

@onready var woodLabel = $woodLabel
@onready var foodLabel = $foodLabel
@onready var coalLabel = $coalLabel
@onready var stoneLabel = $stoneLabel
@onready var temperatureLabel = $temperatureLabel
@onready var ironLabel = $ironLabel
@onready var fiberLabel = $fiberLabel

@onready var actions_set = $Actions_Set
@onready var dice_rest = $dice_rest


@export var dice_count: int = 0
var stored_dices = {}


func _ready():
	randomize()
	_update_ui_labels_with_initial_values()
	Resources.connect("resource_updated", _on_resource_updated)
	dice_rest.connect("is_night", start_night)


func _update_ui_labels_with_initial_values() -> void:
	print(woodLabel.text)
	# Aggiorna ciascuna etichetta con il valore iniziale corrispondente
	woodLabel.text = "Wood: " + str(Resources.resources[Enums.resources.WOOD])
	foodLabel.text = "Food: " + str(Resources.resources[Enums.resources.FOOD])
	coalLabel.text = "Coal: " + str(Resources.resources[Enums.resources.COAL])
	stoneLabel.text = "Stone: " + str(Resources.resources[Enums.resources.STONE])
	temperatureLabel.text = "Temperature: " + str(Resources.resources[Enums.resources.TEMPERATURE])
	ironLabel.text = "Iron: " + str(Resources.resources[Enums.resources.IRON])
	fiberLabel.text = "Fiber: " + str(Resources.resources[Enums.resources.FIBER])
	
func _on_resource_updated(resource_name: String, new_value) -> void:
	var label
	match resource_name:
		"temperature": label = temperatureLabel
		"wood": label =  woodLabel
		"food": label =  foodLabel
		"coal": label =  coalLabel
		"stone": label = stoneLabel
		"iron": label = ironLabel
		"fiber": label = fiberLabel
		_: return
	label.text = "%s: %s" % [resource_name.capitalize(), str(new_value)]
	ActionManager.update_actions_resources()


func start_night():
	print("entra!")
	select_random_event()
	dice_rest._feed_characters()
	dice_rest.remove_character_bonuses()
	dice_rest._load_player()
	dice_rest._load_companions()
	actions_set._refresh_daily_limit()


func select_random_event() -> void:
	var event = randi() % Enums.random_events.size()
	event = 2 #testing, rimuovere
	var test = test_dialog.instantiate()
	test.get_child(0).title = Enums.events_descriptions[event]["title"]
	test.get_child(0).dialog_text = Enums.events_descriptions[event]["description"]
	add_child(test)
	handle_event(event)

func handle_event(event: int) -> void:
	match event:
		Enums.random_events.QUIET_NIGHT:
			Resources.quiet_night_event()
		Enums.random_events.ICY_NIGHT:
			Resources.icy_night_event()
		Enums.random_events.COLD_NIGHT:
			Resources.cold_night_event()
