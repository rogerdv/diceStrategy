extends Node2D

var selected = false
var rest_point
var rest_nodes = []
var default_rest_point 
var default_rest_nodes = []
var is_at_rest_point = false 
var closest_node = null
const ARRIVAL_THRESHOLD = 1
const SPEED_THRESHOLD = 0.1
const DISTANCE_THRESHOLD = 75 * 75
var flag: bool

@export var character = ""
signal inner_dice_removed
signal dice_removed

func _exit_tree():
	emit_signal("dice_removed")

func _update_drop_zones():
	_ready()

func _ready():
	rest_nodes = get_tree().get_nodes_in_group("zona_drop")
	default_rest_nodes = get_tree().get_nodes_in_group("zona_rest")
	
	var assigned_node = false # Flag per tenere traccia se abbiamo già assegnato un nodo

	# Cerca prima un nodo non occupato specifico per il personaggio
	for n in default_rest_nodes:
		if not n.occupied and n.character == character:
			assign_rest_point(n)
			assigned_node = true
			break # Interrompe il ciclo una volta trovato il nodo specifico

	# Se non è stato trovato un nodo specifico per il personaggio, cerca il primo nodo libero
	if not assigned_node:
		for n in default_rest_nodes:
			if not n.occupied:
				assign_rest_point(n, true) # Assegna e imposta il carattere se necessario
				break

func assign_rest_point(node, set_character = false):
	node.occupy()
	if set_character:
		node.character = character # Assegna il personaggio solo se necessario
	default_rest_point = node.global_position
	rest_point = default_rest_point
	closest_node = node
 

var returning_to_rest_point = false  

func _process(delta):
	var previous_position = global_position
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 45 * delta)
		returning_to_rest_point = false  # Assicurati di resettare quando l'oggetto è selezionato
	elif returning_to_rest_point:
		# Chiama return_to_rest_point solo se l'oggetto deve tornare al suo punto di riposo
		return_to_rest_point()
		# Verifica se l'oggetto ha raggiunto il rest_point per fermare il ritorno
		if global_position.distance_to(rest_point) < ARRIVAL_THRESHOLD:
			returning_to_rest_point = false
			is_at_rest_point = true
	else:
		if is_near_drop_zone():
			global_position = lerp(global_position, rest_point, 15 * delta)
		elif not is_at_rest_point:
			global_position = lerp(global_position, default_rest_point, 15 * delta)

	# La logica per controllare l'arrivo al rest_point può rimanere qui se necessario
	check_arrival_at_rest_point(previous_position, delta)


func check_arrival_at_rest_point(previous_position, delta):
	var distance_to_rest_point = global_position.distance_squared_to(rest_point)
	var movement_speed = (global_position - previous_position).length_squared() / (delta * delta)

	if distance_to_rest_point <= ARRIVAL_THRESHOLD * ARRIVAL_THRESHOLD and movement_speed <= SPEED_THRESHOLD * SPEED_THRESHOLD:
		is_at_rest_point = true
		if closest_node and closest_node.has_method("assign_value"):
			if(closest_node.refuse(get_node("Sprite2D").dice_value)):
				returning_to_rest_point = true
			else:
				closest_node.assign_value(get_node("Sprite2D").dice_value, character)
				emit_signal("inner_dice_removed")
				for n in default_rest_nodes:
					if n.character == character:
						n.unoccupy()
				if closest_node.should_consume_dice():
					queue_free()
				else:
					returning_to_rest_point = true
	else:
		is_at_rest_point = false


func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_released():
			selected = false
			find_closest_drop_zone()
			find_closest_rest_point()


func find_closest_rest_point():
	var shortest_dist = DISTANCE_THRESHOLD     
	for child in rest_nodes:
		if child.disabled:
			continue
		var distance = global_position.distance_squared_to(child.global_position)
		if distance < shortest_dist:
			if closest_node != child:
				closest_node = child
			rest_point = child.global_position
			shortest_dist = distance

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		selected = true
		
func is_near_drop_zone():
	return global_position.distance_squared_to(closest_node.global_position) < DISTANCE_THRESHOLD
	
func find_closest_drop_zone():
	var found: bool = false
	var shortest_dist = DISTANCE_THRESHOLD
	var tab_container = get_node("/root/Main/Actions_Set/TabContainer") # Adjust the path to your TabContainer node
	var current_tab_index = tab_container.get_current_tab()

	for child in rest_nodes:
		# You might need to adjust the parent access here depending on your scene structure
		var child_tab_index = child.get_parent().get_parent().get_parent().get_parent().get_index()
		if child.disabled or child_tab_index != current_tab_index:
			continue

		var distance = global_position.distance_squared_to(child.global_position)
		if distance < shortest_dist:
			print(child_tab_index,  " ", current_tab_index)
			print(child.get_parent().get_parent().action_name)
			found = true
			shortest_dist = distance
			closest_node = child
			rest_point = child.global_position

	if not found:
		flag = true
		returning_to_rest_point = true # Ensures the die returns to its rest point if no valid drop zone is found


# Function to smoothly return the object to its rest point
func return_to_rest_point():
	if global_position != default_rest_point:
		global_position = lerp(global_position, default_rest_point, 0.2)


func _gets_sick():
	get_node("Sprite2D")._gets_sick()

func _gets_boosted():
	get_node("Sprite2D")._gets_boosted()

func _gets_healthy():
	get_node("Sprite2D")._gets_healthy()

func _assign_character(char_name):
	character = char_name
