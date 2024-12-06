extends Node2D

@onready var richlabel = get_node("Sprite2D/RichTextLabel")

@export var custom_text: String = "Default Text"
@export var value_given: int = 0
@export var person_give: String = ""
@export var action_type: Enums.action_types
@export var disabled: bool = false
@export var tot_limit: int = 999
@export var fixed_daily_limit: int = 999
@export var daily_limit: int = 0
@export var action_name: String = ""
@export var person_name: String = ""
@export var craft: bool = false
@export var resources_needed: Dictionary = {}
@export var manpower: int = 0
@export var manpower_fixed: int = 0
@export var consumes_dice: bool = true
signal enable_action
signal manpower_changed
signal total_limit_finished


func _ready():
	daily_limit = fixed_daily_limit
	is_starting_disabled()
	var text_edit = get_node("TextEdit")
	text_edit.text = custom_text
	if manpower != 0:
		richlabel.text = str(manpower_fixed)
	Resources.connect("tool_crafted", Callable(self, "on_tool_crafted"))
	connect("enable_action", Callable(self, "enable"))
	connect("manpower_changed", Callable(self, "on_manpower_changed"))
	connect("total_limit_finished", Callable(self, "on_total_limit_finished"))
	Resources.connect("resource_updated", Callable(self, "check_resources_needed"))


func _process(_delta):
	if(value_given != 0):
		execute_action(value_given, person_name)
		value_given = 0
		person_name = ""

func on_manpower_changed():
	if manpower == 0:
		Resources.build(ActionManager.match_action_resource[action_type], false)
		manpower = manpower_fixed
		richlabel.text = str(manpower)
	richlabel.text = str(manpower)

func is_starting_disabled():
	if daily_limit == 0 or disabled == true:
		disable()
		return

func on_total_limit_finished() -> void:
	print("total_limit finito")
	daily_limit = 0
	fixed_daily_limit = 0
	disable()

func disable() -> void:
	disabled = true
	var drop_node = get_node("Sprite2D/drop_zone")
	if(drop_node):
		drop_node.disable()

	var sprite_node = get_node("Sprite2D")
	if sprite_node:
		sprite_node.modulate = Color(0.5, 0.5, 0.5) 
	set_process_input(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)

func enable() -> void:
	disabled = false
	if visible == true:
		#Enums.actions[action_name]["disabled"] = false
		var drop_node = get_node("Sprite2D/drop_zone")
		if drop_node:
			drop_node.enable()
		var sprite_node = get_node("Sprite2D")
		if sprite_node:
			sprite_node.modulate = Color(1, 1, 1) 

		set_process_input(true)
		set_process_unhandled_input(true)
		set_process_unhandled_key_input(true)

func hide_action() -> void:
	visible = false
	var drop_node = get_node("Sprite2D/drop_zone")
	if(drop_node):
		drop_node.disable()
	set_process_input(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)

		
func show_action() -> void:
	visible = true
	set_process_input(not disabled)
	set_process_unhandled_input(not disabled)
	set_process_unhandled_key_input(not disabled)

	if not disabled:
		enable()
		var drop_node = get_node_or_null("Sprite2D/drop_zone")
		if drop_node is Node:  # Check if drop_node is valid
			drop_node.enable()  # Assumes enable() is defined for drop_node


	
func check_resources_needed(_name = "", _res = null) -> void: #forse può essere migliorata
	if len(resources_needed.keys()) < 0:
		return
	for resource in resources_needed:
		if Resources.resources[resource] <= resources_needed[resource]:
			disable()
			return

	if tot_limit > 0 && daily_limit > 0:
		enable()



func on_tool_crafted(tool_name: int):
	match tool_name:
		Enums.resources.PICKAXE: 
			if action_type == Enums.action_types.HARVESTING_STONE or action_type == Enums.action_types.HARVESTING_COAL or action_type == Enums.action_types.HARVESTING_IRON:
				if fixed_daily_limit == 0:
					enable()
				fixed_daily_limit += 1 
				daily_limit = fixed_daily_limit
		Enums.resources.SPEAR: 
			if fixed_daily_limit == 0:
				enable()
			if action_type == Enums.action_types.HUNT_WITH_SPEAR:
				fixed_daily_limit += 1
				daily_limit = fixed_daily_limit
		Enums.resources.BOW:
			if fixed_daily_limit == 0:
				enable()
			if action_type == Enums.action_types.HUNT_WITH_BOW:
				fixed_daily_limit = Resources.resources[Enums.resources.ARROW]
				daily_limit = fixed_daily_limit
		Enums.resources.TRAP:
			if fixed_daily_limit == 0:
				enable()
			if action_type == Enums.action_types.HUNT_WITH_TRAP:
				fixed_daily_limit += 1
				daily_limit = fixed_daily_limit


	
	
func execute_action(value, person)  -> void:
	tot_limit -= 1
	if tot_limit == 0:
		total_limit_finished.emit()
	daily_limit -= 1
	match action_type:
		Enums.action_types.WOOD_HARVESTING:
			Resources.wood_harvesting(value)
			Resources.build(ActionManager.match_action_resource[Enums.action_types.BUILD_PICKAXE], true) #TESTING
		Enums.action_types.FIBER_HARVESTING:
			Resources.fiber_harvesting(value)
		Enums.action_types.FOOD_HARVESTING:
			Resources.food_harvesting(value)
		Enums.action_types.MAKE_CHARCOAL:
			Resources.make_charcoal(value)
		Enums.action_types.HARVESTING_STONE:
			Resources.harvesting_stone(value)
		Enums.action_types.HARVESTING_COAL:
			Resources.harvesting_coal(value)
		Enums.action_types.HARVESTING_IRON:
			Resources.harvesting_iron(value)
		Enums.action_types.EXPLORATION:
			Resources.exploration()
		Enums.action_types.HUNT_NO_WEAPONS:
			Resources.hunt_no_weapons(value, person)
		Enums.action_types.HUNT_WITH_SPEAR:
			Resources.hunt_with_spear(value, person)
		Enums.action_types.HUNT_WITH_BOW:
			Resources.hunt_with_bow(value, person)
		Enums.action_types.HUNT_WITH_TRAP:
			Resources.hunt_with_trap(value)
		11,12,13,14,15,16,17,18,19,20: #buildings
			manpower -= 1
			manpower_changed.emit()
		Enums.action_types.IMPROVE_BONFIRE:
			Resources.improve_bonfire(value)
		Enums.action_types.QUICK_NAP:
			CharacterManager.characters[person].reroll()
		Enums.action_types.INSPIRING_SPEECH: #DA CONCLUDERE
			#print(get_tree().get_nodes_in_group("character"))
			for character in get_tree().get_nodes_in_group("character"):
				if character != CharacterManager.characters[person]:
					character.reroll_if_dice_present()
		Enums.action_types.TRAINING:
			var l = []
			for character in get_tree().get_nodes_in_group("character"):
				if !character.sick and character != CharacterManager.characters[person]:
					l.append(character)
			if l.size() > 0:
				var random_index = randi_range(0, l.size() - 1)
				var random_character = l[random_index]
				random_character.boosted = true
		Enums.action_types.REST:
			CharacterManager.characters[person].rested = true
			
	if(daily_limit == 0 or tot_limit == 0):
		disable()

func should_refuse(value: int) -> bool:
	match action_type:
		Enums.action_types.MAKE_CHARCOAL:
			if Resources.resources[Enums.resources.WOOD] >= value:
				return false
			else:
				return true
	return false

