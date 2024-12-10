extends Node2D

const DiceScenePath: String = "res://scenes/all_dice/dice.tscn"
var dice_scene = preload(DiceScenePath)
signal player_removed
signal dice_added
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_dice():
	var dice = dice_scene.instantiate()
	dice.connect("inner_dice_removed", _on_inner_dice_removed)
	dice._assign_character("player")
	dice.scale = Vector2(0.4, 0.4)
	add_child.call_deferred(dice)
	
func _on_inner_dice_removed():
	emit_signal("player_removed")

func reroll() -> void:
	emit_signal("dice_added")
	call_deferred("set_dice")
