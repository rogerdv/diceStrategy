extends Marker2D

@export var occupied: bool = false
@export var character : String
func _ready():
	pass # Replace with function body.


func occupy() -> void:
	occupied = true

func unoccupy() -> void:
	occupied = false
