extends Node

signal resource_updated(resource_name, new_value)
signal dead_person(person_name)
signal housed_character(character)
signal not_housed_character(character)
signal tool_crafted(tool_name)
signal building_repaired(building)
signal building_destroyed(building)
#resources

enum buildings_statuses {
	TO_BUILD,
	BUILT,
	BROKEN
}

var resources = {
	Enums.resources.WOOD: 0, 
	Enums.resources.FIBER: 0,
	Enums.resources.FOOD: 0,
	Enums.resources.STONE: 0, 
	Enums.resources.IRON: 0, 
	Enums.resources.COAL: 0, 
	Enums.resources.TEMPERATURE: 10, 
	Enums.resources.TEMPERATURE_MODIFIER: 0,
	Enums.resources.MATCHES: 5,
	
	Enums.resources.SPEAR: 0, 
	Enums.resources.BOW: 0, 
	Enums.resources.ARROW: 0, 
	Enums.resources.TRAP: 0,
	
	Enums.resources.PICKAXE: 0, 
	Enums.resources.CART: 0, 
	Enums.resources.SAW: 0, 
	
	Enums.resources.OVEN: buildings_statuses.TO_BUILD, 
	Enums.resources.BIG_OVEN: buildings_statuses.TO_BUILD, 
	Enums.resources.WAREHOUSE: buildings_statuses.TO_BUILD, 
	Enums.resources.BIG_WAREHOUSE: buildings_statuses.TO_BUILD, 
	Enums.resources.FENCES: buildings_statuses.TO_BUILD,

	Enums.resources.BONFIRE: 0, 
	Enums.resources.BONFIRE_ACTIVE: false, 
	Enums.resources.BONFIRE_COVER: buildings_statuses.TO_BUILD

}

#limits
@export var resources_limits: Dictionary = {
	"normal": {
		"limit": 25,
		"active": true
	},
	"warehouse": {
		"limit": 55,
		"active": false,
	},
	"big_warehouse": {
		"limit": 100,
		"active": false
	}
}

#habitations
@export var housing_structures: Dictionary = {
	"shelters_max" : 1,
	"shelters_durability": 15,
	"shelters_sick_resistance": 10,
	"refuge_max" : 2,
	"refuge_durability": 35,
	"refuge_sick_resistance": 25,
	"house_max" : 3,
	"house_durability": 55,
	"house_sick_resistance": 45,
	"improvised_shelters": [],
	"simple_refuges": [],
	"simple_houses": [],
}

func _ready():
	randomize()

func food_eaten(character):
	var food_consumption = calculate_food_consumption(resources[Enums.resources.TEMPERATURE], character.rested)
	
	if resources[Enums.resources.FOOD] >= food_consumption:
		resources[Enums.resources.FOOD] -= food_consumption
		character.days_no_food = 0
	else:
		character.days_no_food += 1
	
	emit_signal("resource_updated", "food", resources[Enums.resources.FOOD])

func calculate_food_consumption(temperature, rested) -> int:
	var food_required:int = 1 # Default food requirement
	if temperature <= 9 and temperature >= 1:
		food_required = 1 if rested else 2
	elif temperature <= -1 or (temperature >= 10 and temperature <= 19) or temperature == -20:
		food_required = 2 if rested else 3
	elif temperature <= -10 and temperature > -20:
		food_required = 2 if rested else 4
	if temperature == -20:
		food_required = 3 if rested else 5
	return food_required


func food_eaten_sick(character):
	var food_consumption = calculate_food_consumption_sick(resources[Enums.resources.TEMPERATURE], character.rested)
	if resources[Enums.resources.FOOD] >= food_consumption:
		resources[Enums.resources.FOOD] -= food_consumption
		character.days_no_food = 0
	else:
		character.days_no_food += 1
	
	emit_signal("resource_updated", "food", resources[Enums.resources.FOOD])

func calculate_food_consumption_sick(temperature, rested) -> int:
	var food_required = 4 # Base requirement for sick characters in mild temperatures
	if temperature in range(1, 11): # Temperature between 1 and 10 inclusive
		food_required = 2 if rested else 4 # Reduced requirement if rested
	elif temperature == -20:
		food_required = 3 if rested else 6# Special case for extreme cold
	else:
		food_required = 3 if rested else 5 # Default case for other temperatures
	return food_required


func apply_resource_deduction(severity: int) -> void:
	var percentage: float
	var chance: float
	var buildings: bool = false
	
	var first_five_resources = [
		Enums.resources.WOOD,
		Enums.resources.FOOD,
		Enums.resources.STONE,
		Enums.resources.IRON,
		Enums.resources.COAL
	]

	match severity:
		1:
			percentage = randf_range(0.1, 0.2) # 10% to 20%
			chance = 0.3 # 30% chance for each resource to be affected
		2:
			percentage = randf_range(0.1, 0.25) # 10% to 25%
			chance = 0.5 # 50% chance for each resource to be affected
		3:
			buildings = true
			percentage = randf_range(0.2, 0.35) # 20% to 40%
			chance = 0.7 # 70% chance for each resource to be affected
	
	for resource in first_five_resources:
		if randf() < chance:
			var original_value = resources[resource]
			var deduction = original_value * percentage
			resources[resource] = max(0, original_value - deduction)

			emit_signal("resource_updated", resource, resources[resource])
			
	if buildings:
		destroy_building()
		

func apply_resource_increase(severity: int) -> void:
	var increase_min: int
	var increase_max: int
	var chance: float

	var first_five_resources = [
		Enums.resources.WOOD,
		Enums.resources.FOOD,
		Enums.resources.STONE,
		Enums.resources.IRON,
		Enums.resources.COAL
	]
	
	match severity:
		1:
			increase_min = 5
			increase_max = 10
			chance = 0.3 # 30% chance for each of the first five resources to be increased
		2:
			increase_min = 5
			increase_max = 15
			chance = 0.4 # 40% chance for each of the first five resources to be increased
		3:
			increase_min = 10
			increase_max = 25
			chance = 0.5 # 50% chance for each of the first five resources to be increased

	for resource in first_five_resources:
		if randf() < chance:
			var increase = randi_range(increase_min, increase_max)
			resources[resource] += increase

			emit_signal("resource_updated", resource, resources[resource])
	


func get_limit():
	if resources_limits["normal"]["active"]:
		return resources_limits["normal"]["limit"]
	elif resources_limits["warehouse"]["active"]:
		return resources_limits["warehouse"]["limit"]
	elif resources_limits["big_warehouse"]["active"]:
		return resources_limits["big_warehouse"]["limit"]
	return -1
	
func consume_bonfire():
	if resources[Enums.resources.BONFIRE_ACTIVE] == true:
		match resources[Enums.resources.TEMPERATURE]:
			10,9,8,7,6,5,4,3,2,1:
				if resources[Enums.resources.BONFIRE] >= 2:
					resources[Enums.resources.BONFIRE] -= 2
				else:
					resources[Enums.resources.BONFIRE_ACTIVE] = false
					resources[Enums.resources.BONFIRE] = 0
			0,-1,-2,-3,-4,-5,-6,-7,-8,-9:
				if resources[Enums.resources.BONFIRE] >= 3:
					resources[Enums.resources.BONFIRE] -= 3
				else:
					resources[Enums.resources.BONFIRE_ACTIVE] = false
					resources[Enums.resources.BONFIRE] = 0
			-10,-11,-12,-13,-14,-15,-16,-17,-18,-19:
				if resources[Enums.resources.BONFIRE] >= 4:
					resources[Enums.resources.BONFIRE] -= 4
				else:
					resources[Enums.resources.BONFIRE_ACTIVE] = false
					resources[Enums.resources.BONFIRE] = 0
			-20:
				if resources[Enums.resources.BONFIRE] >= 5:
					resources[Enums.resources.BONFIRE] -= 5
				else:
					resources[Enums.resources.BONFIRE_ACTIVE] = false
					resources[Enums.resources.BONFIRE] = 0

#actions (harvesting or producing resources)
func wood_harvesting(value: int) -> void: #add value if saw
	if(resources[Enums.resources.SAW]):
		value += 2
	var limit = get_limit()
	if value > limit - resources[Enums.resources.WOOD]:
		value = limit - resources[Enums.resources.WOOD]
	resources[Enums.resources.WOOD] += value
	emit_signal("resource_updated", "wood", resources[Enums.resources.WOOD])

	var dice_roll = randi() % 100 + 1
	
	# Se il risultato è sotto 20, esegue un secondo lancio da 1 a 3
	if dice_roll < 20:
		var secondary_roll = randi() % 3 + 1
		# Qui puoi aggiungere la logica che gestisce il secondo lancio
		if secondary_roll > limit - resources[Enums.resources.FIBER]:
			secondary_roll = limit - resources[Enums.resources.FIBER]
		resources[Enums.resources.FIBER] += secondary_roll
		emit_signal("resource_updated", "fiber", resources[Enums.resources.FIBER])
	
func fiber_harvesting(value: int) -> void:
	var limit = get_limit()
	if value > limit - resources[Enums.resources.FIBER]:
		value = limit - resources[Enums.resources.FIBER]
	resources[Enums.resources.FIBER] += value
	emit_signal("resource_updated", "fiber", resources[Enums.resources.FIBER])

func food_harvesting(value: int)  -> void:
	var reduction_percentage = randi() % 4  # Randomly pick 0, 1, 2, or 3
	var reduction_factor = 1.0  # Default to no reduction
	# Assign reduction_factor based on reduction_percentage
	match reduction_percentage:
		0:
			reduction_factor = 0.5  # 50% reduction
		1:
			reduction_factor = 0.75  # 25% reduction
		2:
			reduction_factor = 0.9  # 10% reduction
		3:
			reduction_factor = 1.0  # No reduction
	# Apply reduction and ensure final value is at least 1
	var final_value = max(1, int(value * reduction_factor))
	var limit = get_limit()
	if final_value > limit - resources[Enums.resources.FOOD]:
		final_value = limit - resources[Enums.resources.FOOD]
	resources[Enums.resources.FOOD] += final_value
	emit_signal("resource_updated", "food", resources[Enums.resources.FOOD])

func make_charcoal(wood_used: int)  -> void:
	#TODO: rifiuto dado se non basta il legno e metodo, ora solo placeholder
	var limit = get_limit()
	if wood_used > limit - resources[Enums.resources.COAL]:
		wood_used = limit - resources[Enums.resources.COAL]
		
	resources[Enums.resources.COAL] += wood_used
	resources[Enums.resources.WOOD] -= wood_used
	emit_signal("resource_updated", "coal", resources[Enums.resources.COAL])
	emit_signal("resource_updated", "wood", resources[Enums.resources.WOOD])

func harvesting_stone(value: int)  -> void:
	var reduction_percentage = randi() % 3  # Randomly pick 0, 1, or 2
	var reduction_factor = 1.0  # Default to no reduction

	# Assign reduction_factor based on reduction_percentage
	match reduction_percentage:
		0:
			reduction_factor = 0.8  # 20% reduction
		1:
			reduction_factor = 0.7  # 30% reduction
		2:
			reduction_factor = 1.0  # No reduction
	# Apply reduction and ensure final value is at least 1
	var final_value = max(1, int(value * reduction_factor))
	var limit = get_limit()
	if final_value > limit - resources[Enums.resources.STONE]:
		final_value = limit - resources[Enums.resources.STONE]
	resources[Enums.resources.STONE] += final_value
	emit_signal("resource_updated", "stone", resources[Enums.resources.STONE])


func harvesting_coal(value:int) -> void:
	var reduction_percentage = randi() % 3  # Randomly pick 0, 1, or 2
	var reduction_factor = 1.0  # Default to no reduction

	# Assign reduction_factor based on reduction_percentage
	match reduction_percentage:
		0:
			reduction_factor = 0.8  # 20% reduction
		1:
			reduction_factor = 0.7  # 30% reduction
		2:
			reduction_factor = 1.0  # No reduction
	# Apply reduction and ensure final value is at least 1
	var final_value = max(1, int(value * reduction_factor))
	var limit = get_limit()
	if final_value > limit - resources[Enums.resources.COAL]:
		final_value = limit - resources[Enums.resources.COAL]
	resources[Enums.resources.COAL] += final_value
	emit_signal("resource_updated", "coal", resources[Enums.resources.COAL])
	
func harvesting_iron(value:int) -> void:
	var limit = get_limit()
	if value > limit - resources[Enums.resources.IRON]:
		value = limit - resources[Enums.resources.IRON]
	resources[Enums.resources.IRON] += value
	emit_signal("resource_updated", "iron", resources[Enums.resources.IRON])
func exploration() -> void:
	pass #tbd
	
func hunt_no_weapons(value: int, person):
	# 35% chance of losing the unit
	if randf() < 0.25:
		#Enums.people[person]["dead"] = true
		emit_signal("dead_person", person)
		return

	# If the unit is not lost, 35% chance of returning without anything
	if randf() < 0.25:
		print("Returned empty-handed")
		return  # Ends the function here if returned empty-handed

	# If neither of the above, add X+5 to food
	resources[Enums.resources.FOOD] += value + 5
	emit_signal("resource_updated", "food", resources[Enums.resources.FOOD])

func hunt_with_spear(value: int, person):
	print(person)
	# 35% chance of losing the unit
	if randf() < 0.65:
		Enums.people[person]["dead"] = true
		emit_signal("dead_person", person)
		return  #person.dead  # Ends the function here if the unit is lost

	# If the unit is not lost, 35% chance of returning without anything
	if randf() < 0.25:
		print("Returned empty-handed")
		return  # Ends the function here if returned empty-handed

	# If neither of the above, add X+5 to food
	resources[Enums.resources.FOOD] += value + 5
	emit_signal("resource_updated", "food", resources[Enums.resources.FOOD])
	
func hunt_with_bow(value: int, person):
	print(person)
	resources[Enums.resources.ARROW] -= 1
	# 35% chance of losing the unit
	if randf() < 0.05:
		Enums.people[person]["dead"] = true
		emit_signal("dead_person", person)  #person.dead  # Ends the function here if the unit is lost
		return
		
	# If the unit is not lost, 35% chance of returning without anything
	if randf() < 0.15:
		print("Returned empty-handed")
		return  # Ends the function here if returned empty-handed

	# If neither of the above, add X+5 to food
	resources[Enums.resources.FOOD] += value + 5
	emit_signal("resource_updated", "food", resources[Enums.resources.FOOD])
	
func hunt_with_trap(value):
	resources[Enums.resources.TRAP] -= 1
	if randf() < 0.3:
		print("Returned empty-handed")
		return
		
	resources[Enums.resources.FOOD] += value + 5
	emit_signal("resource_updated", "food", resources[Enums.resources.FOOD])
	

enum action_types {
	#Resources
	WOOD_HARVESTING,
	FOOD_HARVESTING,
	MAKE_CHARCOAL,

	BUILD_WAREHOUSE,
	BUILD_BIG_WAREHOUSE,
	#Tools
	BUILD_SPEAR,
	BUILD_BOW,
	BUILD_ARROW,
	BUILD_TRAP,
	BUILD_SAW,
	BUILD_PICKAXE,
	BUILD_CART,
	BUILD_BONFIRE,
	IMPROVE_BONFIRE
}
#DA TESTARE
func build_housing(type):
	var free_characters = CharacterManager.get_is_not_housed_list()
	match type:
		Enums.action_types.BUILD_IMPROVISED_SHELTER:
			var l = []
			if len(free_characters) > 0:
				l.append(free_characters.pop_front())
				emit_signal("housed_character", l[0])
			housing_structures["improvised_shelters"].append({"characters": l, "status": buildings_statuses.BUILT})
		Enums.action_types.BUILD_SIMPLE_REFUGE:
			var l = []
			if len(free_characters) > 0:
				for x in range(housing_structures["refuge_max"]):
					if free_characters.size() > 0:
						var c = free_characters.pop_front()
						emit_signal("housed_character", c)
						l.append(c)
			housing_structures["simple_refuges"].append({"characters": l, "status": buildings_statuses.BUILT})
		Enums.action_types.BUILD_SIMPLE_HOUSE:
			var l = []
			if len(free_characters) > 0:
				for x in range(housing_structures["house_max"]):
					if free_characters.size() > 0:
						var c = free_characters.pop_front()
						emit_signal("housed_character", c)
						l.append(c)
			housing_structures["simple_houses"].append({"characters": l, "status": buildings_statuses.BUILT})



func house_character(character):
	var structure_types = [
		{"type": "simple_houses", "max": housing_structures["house_max"]},
		{"type": "simple_refuges", "max": housing_structures["refuge_max"]},
		{"type": "improvised_shelters", "max": housing_structures["shelters_max"]}
	]

	for structure in structure_types:
		for x in housing_structures[structure["type"]]:
			if len(x) < structure["max"]:
				x.append(character)
				emit_signal("housed_character", character)
				return
				
func destroy_building():
	# Lista dei tipi di strutture con la relativa durabilità
	var structure_types = [
		{"type": "improvised_shelters", "durability": housing_structures["shelters_durability"]},
		{"type": "simple_refuges", "durability": housing_structures["refuge_durability"]},
		{"type": "simple_houses", "durability": housing_structures["house_durability"]}
	]
	
	# Numero casuale di strutture da controllare
	var structures_to_check = randi() % 3 + 1  # Genera un numero da 1 a 3
	
	for i in range(structures_to_check):
		# Seleziona un tipo di struttura casuale
		var selected_structure = structure_types[randi() % structure_types.size()]
		
		# Seleziona una struttura casuale di quel tipo, se presente
		if housing_structures[selected_structure["type"]].size() > 0:
			var random_index = randi() % housing_structures[selected_structure["type"]].size()
			var structure = housing_structures[selected_structure["type"]][random_index]
			
			# Verifica se la struttura viene distrutta
			var roll = randi() % 100 + 1  # Genera un numero da 1 a 100
			if roll > selected_structure["durability"]:
				housing_structures[selected_structure["type"]][i]["status"] = buildings_statuses.BROKEN
				for x in housing_structures[selected_structure["type"]][i]["characters"]:
					emit_signal("not_housed_character", x)
			else:
				print("Una struttura di tipo", selected_structure["type"], "resiste.")

func destroy_building_with_severity(damage_severity):
	# Lista dei tipi di strutture con la relativa durabilità
	var structure_types = [
		{"type": "improvised_shelters", "durability": housing_structures["shelters_durability"]},
		{"type": "simple_refuges", "durability": housing_structures["refuge_durability"]},
		{"type": "simple_houses", "durability": housing_structures["house_durability"]}
	]
	
	# Modifica della probabilità di distruzione basata sulla severità dei danni
	var destruction_probability_modifier = 0
	match damage_severity:
		1: destruction_probability_modifier = 0.75  # Minore probabilità di distruzione
		2: destruction_probability_modifier = 1.0   # Probabilità di distruzione standard
		3: destruction_probability_modifier = 1.25  # Maggiore probabilità di distruzione
	
	for selected_structure in structure_types:
		# Controlla tutte le strutture del tipo selezionato
		for i in range(housing_structures[selected_structure["type"]].size()):
			var roll = randi() % 100 + 1  # Genera un numero da 1 a 100
			if roll > selected_structure["durability"] * destruction_probability_modifier:
				print("Una struttura di tipo", selected_structure["type"], "è stata distrutta a causa della severità del danno", damage_severity, ".")
				housing_structures[selected_structure["type"]][i]["status"] = buildings_statuses.BROKEN
				for x in housing_structures[selected_structure["type"]][i]["characters"]:
					emit_signal("not_housed_character", x)
			else:
				print("Una struttura di tipo", selected_structure["type"], "resiste nonostante la severità del danno", damage_severity, ".")


func destroy_oven() -> void:
	var roll = randi() % 100 + 1
	if roll > 45:
		resources[Enums.resources.OVEN] = buildings_statuses.BROKEN
		emit_signal("building_destroyed", Enums.resources.OVEN)

func destroy_big_oven() -> void:
	var roll = randi() % 100 + 1
	if roll > 70:
		resources[Enums.resources.BIG_OVEN] = buildings_statuses.BROKEN
		emit_signal("building_destroyed", Enums.resources.BIG_OVEN)

func destroy_bonfire_cover() -> void:
	var roll = randi() % 100 + 1
	if roll > 30:
		resources[Enums.resources.BONFIRE_COVER] = buildings_statuses.BROKEN
		emit_signal("building_destroyed", Enums.resources.BONFIRE_COVER)

func destroy_fences() -> void:
	var roll = randi() % 100 + 1
	if roll > 40:
		resources[Enums.resources.FENCES] = buildings_statuses.BROKEN
		emit_signal("building_destroyed", Enums.resources.FENCES)

func destroy_from_all_buildings() -> void:
	for i in range(3):
		#oven, big_oven, bonfire_cover e buildings1, buildings2, buildings3, nulla, nulla, nulla
		var check = randi() % 10 + 1
		match check:
			1: destroy_oven()
			2: destroy_big_oven()
			3: destroy_bonfire_cover()
			4: destroy_building_with_severity(1)
			5: destroy_building_with_severity(2)
			6: destroy_building_with_severity(3)
			7: destroy_fences()
			_: print("nulla!")
	


func repair(building_type: Enums.resources) -> void:
	if resources[building_type] == buildings_statuses.BROKEN:
		resources[building_type] = buildings_statuses.BUILT
		emit_signal("building_repaired", building_type)


func build(building_type: Enums.resources, is_tool: bool) -> void: #prototype per building
	if is_tool:
		if building_type == Enums.resources.BONFIRE:
			resources[Enums.resources.BONFIRE] += 5
			resources[Enums.resources.BONFIRE_ACTIVE] = true
		else:
			resources[building_type] += 1
		emit_signal("tool_crafted", building_type)
	resources[building_type] = buildings_statuses.BUILT

func improve_bonfire(value) -> void:
	resources[Enums.resources.BONFIRE] += value
	resources[Enums.resources.WOOD] -= value
	emit_signal("resource_updated", "bonfire", resources[Enums.resources.BONFIRE])
	emit_signal("resource_updated", "wood", resources[Enums.resources.WOOD])


func quiet_night_event() -> void:
	pass

func icy_night_event() -> void:
	resources[Enums.resources.TEMPERATURE] -= 3
	emit_signal("resource_updated", "temperature", resources[Enums.resources.TEMPERATURE] + resources[Enums.resources.TEMPERATURE_MODIFIER])

func cold_night_event() -> void:
	resources[Enums.resources.TEMPERATURE] -= 1
	emit_signal("resource_updated", "temperature", resources[Enums.resources.TEMPERATURE] + resources[Enums.resources.TEMPERATURE_MODIFIER])


func test_destroy():
	emit_signal("building_destroyed", Enums.resources.OVEN)
	
func test_repair():
	emit_signal("building_repaired", Enums.resources.OVEN)
