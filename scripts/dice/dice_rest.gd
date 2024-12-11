extends Control

@onready var grid_container = $GridContainer
@export var dice_count = 0
@onready var player = $player
signal is_night


func _ready():
	mouse_filter = MOUSE_FILTER_PASS
	Resources.connect("dead_person", Callable(self, "_on_dead_companion"))
	Resources.connect("housed_character", Callable(self, "on_housed_character"))
	Resources.connect("not_housed_character", Callable(self, "on_not_housed_character"))
	position_player()
	position_characters(CharacterManager.characters)

func position_player() -> void:
	dice_count += 1
	player.set_dice()
	player.connect("player_removed", Callable(self, "_on_companion_removed"))
	player.connect("dice_added", Callable(self, "_on_dice_added"))

func position_characters(characters: Dictionary):
	for character in characters:
		dice_count += 1
		var control_node = Control.new() 
		var character_node = characters[character] 
		character_node.connect("companion_removed", Callable(self, "_on_companion_removed"))
		character_node.connect("dice_added", Callable(self, "_on_dice_added"))
		control_node.focus_mode = Control.FOCUS_NONE
		control_node.add_child(character_node)
		grid_container.add_child(control_node)

func get_characters():
	var character_list = []
	for x in grid_container.get_children():
		var character = x.get_child(0)
		character_list.append(character)
	return character_list

func position_character(character):
	var control_node = Control.new() 
	var character_node = character
	control_node.focus_mode = Control.FOCUS_NONE
	control_node.add_child(character_node)
	grid_container.add_child(control_node)
	
func _on_dice_added():
	dice_count += 1
	
func _on_dice_removed():
	print("entra!")
	dice_count -= 1
	if dice_count == 0:
		emit_signal("is_night")

func _on_companion_removed():
	dice_count -= 1
	if dice_count == 0:
		emit_signal("is_night")

func _load_player() -> void:
	player.reroll()

func _load_companions() -> void:
	for character in get_characters():
		character.reroll()

func _add_new_character(character) -> void:
	dice_count += 1
	var control_node = Control.new() 
	character.connect("companion_removed", Callable(self, "_on_companion_removed"))
	character.connect("dice_added", Callable(self, "_on_dice_added"))
	Resources.house_character(character)
	control_node.focus_mode = Control.FOCUS_NONE
	control_node.add_child(character)
	grid_container.add_child(control_node)

func remove_character_bonuses() -> void:
	for x in get_characters():
		if x.boosted: x.boosted = false
		if x.rested: x.rested = false
		
func _feed_characters() -> void:
	var characters = get_characters()
	characters.sort_custom(func(a, b):
		return a.days_no_food < b.days_no_food
	)
	for character in characters:
		if character.sick == true:
			Resources.food_eaten_sick(character)
		else:
			Resources.food_eaten(character)

			
func _on_dead_companion(companion) -> void: #da rifare
	CharacterManager.characters.erase(companion)
	
	
	
func on_housed_character(character) -> void:
	var found = get_characters().find(character)
	if found != -1:
		found.is_housed = true

func on_not_housed_character(character) -> void:
		var found = get_characters().find(character)
		if found != -1:
			found.is_housed = false
