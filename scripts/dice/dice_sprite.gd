extends Sprite2D

@export var dice_value: int = 0
var sick: bool = false
var boosted: bool = false
var green_tint: Color = Color(0.8, 1, 0.8) 
var golden_tint: Color = Color(1, 0.9, 0.5, 1)
var sprite_textures = [
	preload("res://game_assets/DicePack/1.png"),
	preload("res://game_assets/DicePack/2.png"),
	preload("res://game_assets/DicePack/3.png"),
	preload("res://game_assets/DicePack/4.png"),
	preload("res://game_assets/DicePack/5.png"),
	preload("res://game_assets/DicePack/6.png"),
	preload("res://game_assets/DicePack/7.png"),
	preload("res://game_assets/DicePack/8.png"),
	preload("res://game_assets/DicePack/9.png"),
]

func _ready():
	randomize()
	roll_dice()
	if sick:
		modulate = green_tint

func roll_dice() -> void: 
	var random_value = (randi() % (3 if sick else 9 if boosted else 6)) + 1
	dice_value = random_value
	self.texture = sprite_textures[random_value - 1]

func _gets_sick() -> void:
	sick = true
	modulate = green_tint
	roll_dice()
	
func _gets_boosted() -> void:
	boosted = true
	modulate = golden_tint
	roll_dice()
func _unboost() -> void:
	boosted = false
	modulate = Color.WHITE
	roll_dice()
func _gets_healthy() -> void:
	sick = false
	modulate = Color.WHITE
	roll_dice()

