extends Node2D

const DiceScenePath: String = "res://scenes/all_dice/dice.tscn"
var dice_scene = preload(DiceScenePath)
#@export var companion = {}
@export var emotions = {}
@export var name_: String
@export var sick: bool
@export var boosted: bool
@export var is_present: bool
@export var dead: bool
@export var is_housed: bool = false
@export var days_no_food: int = 0
@export var has_bed: int = 0
@export var rested: bool = false
signal companion_removed
signal dice_added

func _ready():
	randomize()

func initialize_character():
	_set_emotion("normal")
	get_node("Sprite2D/Sprite2D").scale = Vector2(0.15, 0.15)
	set_dice()
	

func set_dice():
	var dice = dice_scene.instantiate()
	dice.connect("inner_dice_removed", Callable(self, "_on_inner_dice_removed"))
	dice._assign_character(name_)
	dice.scale = Vector2(0.4, 0.4)
	if sick:
		dice._gets_sick()
	if boosted:
		dice._gets_boosted()
	add_child.call_deferred(dice)

func _set_emotion(emotion: String):
	get_node("Sprite2D/Sprite2D").texture = emotions[emotion]

func _on_inner_dice_removed():
	emit_signal("companion_removed")
	
func get_sick():
	#check temperatura
	var prob = 0
	var temperature_prob = {
		10: 0, 9: 0, 8: 0, 7: 0, 6: 0, 5: 0, # Nessuna modifica
		4: 5, 3: 5, 2: 5, # Probabilità aumenta di 5
		1: 10, 0: 10, # Probabilità aumenta di 10
		-1: 15, -2: 15, -3: 15, # E così via...
		-4: 20, -5: 20, -6: 20, -7: 20,
		-8: 30, -9: 30, -10: 30,
		-11: 40, -12: 40, -13: 40,
		-14: 55, -15: 55,
		-16: 75, -17: 75, -18: 75,
		-19: 95, -20: 95,
	}
	prob += temperature_prob.get(Resources.resources[Enums.resources.TEMPERATURE], 0)
	
	prob -=  int(Resources.resources[Enums.resources.BONFIRE] * 0.8)
	
	#check edificio
	if self in Resources.housing_structures["improvised_shelters"]:
		prob -= Resources.housing_structures["shelters_sick_resistance"]
	elif self in Resources.housing_structures["simple_refuges"]:
		prob -= Resources.housing_structures["refuge_sick_resistance"]
	elif self in Resources.housing_structures["simple_houses"]:
		prob -= Resources.housing_structures["house_sick_resistance"]
	if has_bed:
		prob -= 5
	if WeatherManager.actual_weather == WeatherManager.Weather.SUNNY:
		prob -= 10
	
	if prob >= randi() % 100 + 1:
		sick = true
		
func get_boosted():
	var prob = 0
	var roll = randi() % 100 + 1
	if has_bed:
		prob += 5
	if WeatherManager.actual_weather == WeatherManager.Weather.SUNNY:
		prob += 10
	if prob >= roll:
		boosted = true
		
func unsick_with_probability(prob: int):
	if prob > randi() % 100 + 1:
		sick = false
	
func reroll() -> void:
	emit_signal("dice_added")
	call_deferred("set_dice")
	
func reroll_if_dice_present() -> void:
	if get_node("Dice"):
		var dice = get_node("Dice")
		dice.queue_free()
		# Check if the signal is already connected and disconnect it to avoid the error
		if dice.is_connected("dice_removed", Callable(self, "_on_dice_removed")):
			dice.disconnect("dice_removed", Callable(self, "_on_dice_removed"))
		
		# Now safely connect the signal
		dice.connect("dice_removed", Callable(self, "_on_dice_removed"))
		


	
func _on_dice_removed():
	call_deferred("set_dice")
