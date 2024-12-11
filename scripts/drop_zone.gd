extends Marker2D

@export var disabled: bool


	
func assign_value(assigned_value, person_name) -> void:
	var parent_node = get_parent()
	var top_node = parent_node.get_parent()
	top_node.value_given = assigned_value
	top_node.person_name = person_name

func refuse(value: int) -> bool:
	var parent_node = get_parent()
	var top_node = parent_node.get_parent()
	print("refuse? : ",  top_node.should_refuse(value))
	return top_node.should_refuse(value)

func should_consume_dice() -> bool:
	var parent_node = get_parent()
	var top_node = parent_node.get_parent()
	return top_node.consumes_dice

func disable() -> void:
	disabled = true
	
func enable() -> void:
	disabled = false
