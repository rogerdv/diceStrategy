extends Node

const characterPath: String = "res://characters/companion.tscn"
var character_scene = preload(characterPath)

var json_char = {
	"lloyd": {
		"name":"lloyd",
		"images" : {
			"normal": "res://game_assets/companions/Angela/aaaaa.png",
			"sad": "res://game_assets/companions/Lloyd/lloyd_happy.jpg",
			"happy": "res://game_assets/companions/Lloyd/lloyd_happy.jpg",
			"angry": "res://game_assets/companions/Lloyd/lloyd_angry.png"
		},
		"sick":false,
		"is_present": false,
		"dead": false,
	},
	"angela":  {
		"name":"angela",
		"images" : {
			"normal": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"sad": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"happy": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"angry": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg"
		},
		"sick":false,
		"is_present": false,
		"dead": false,
	},
	"franz":  {
		"name":"franz",
		"images" : {
			"normal": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"sad": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"happy": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"angry": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg"
		},
		"sick":false,
		"is_present": false,
		"dead": false,
	},
	"marco":  {
		"name":"marco",
		"images" : {
			"normal": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"sad": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"happy": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"angry": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg"
		},
		"sick":false,
		"is_present": false,
		"dead": false,
	},
	"alice":  {	
		"name":"alice",
		"images" : {
			"normal": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"sad": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"happy": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"angry": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg"
		},
		"sick":false,
		"is_present": false,
		"dead": false,
	},
	"emily":  {
		"name":"emily",
		"images" : {
			"normal": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"sad": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"happy": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"angry": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg"
		},
		"sick":false,
		"is_present": false,
		"dead": false,
	},
	"james":  {
		"name":"james",
		"images" : {
			"normal": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"sad": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"happy": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"angry": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg"
		},
		"sick":false,
		"is_present": false,
		"dead": false,
	},
	"ethan":  {
		"name":"ethan",
		"images" : {
			"normal": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"sad": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"happy": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"angry": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg"
		},
		"sick":false,
		"is_present": false,
		"dead": false,
	},
	"olivia":  {
		"name":"olivia",
		"images" : {
			"normal": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"sad": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"happy": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"angry": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg"
		},
		"sick":false,
		"is_present": true,
		"dead": false,
	},
	"noah":  {
		"name":"noah",
		"images" : {
			"normal": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"sad": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"happy": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"angry": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg"
		},
		"sick":false,
		"is_present": true,
		"dead": false,
	},
	"mia":  {
		"name":"mia",
		"images" : {
			"normal": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"sad": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"happy": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"angry": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg"
		},
		"sick":false,
		"is_present": true,
		"dead": false,
	},
	"aiden":  {
		"name":"aiden",
		"images" : {
			"normal": "res://game_assets/companions/Lloyd/lloyd_angry.png",
			"sad": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"happy": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"angry": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg"
		},
		"sick":true,
		"is_present": true,
		"dead": false,
	},
	"lucas":  {
		"name":"lucas",
		"images" : {
			"normal": "res://game_assets/companions/Lloyd/lloy_normal_temp2.jpg",
			"sad": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"happy": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg",
			"angry": "res://game_assets/companions/Lloyd/lloyd_normal_temp.jpg"
		},
		"sick":false,
		"is_present": true,
		"dead": false,
	},
	"ava":  {
		"name":"ava",
		"images" : {
			"normal": "res://game_assets/companions/Lloyd/lloyd_very_sad.png",
			"sad": "res://game_assets/companions/Lloyd/lloyd_normal_temp3.jpg",
			"happy": "res://game_assets/companions/Lloyd/lloyd_normal_temp3.jpg",
			"angry": "res://game_assets/companions/Lloyd/lloyd_normal_temp3.jpg"
		},
		"sick":false,
		"is_present": true,
		"dead": false,
	},
	"ella":  {
		"name":"ella",
		"images" : {
			"normal": "res://game_assets/companions/Angela/Angela.png",
			"sad": "res://game_assets/companions/Lloyd/lloyd_normal_temp3.jpg",
			"happy": "res://game_assets/companions/Lloyd/lloyd_normal_temp3.jpg",
			"angry": "res://game_assets/companions/Lloyd/lloyd_normal_temp3.jpg"
		},
		"sick":false,
		"is_present": true,
		"dead": false,
	},
}

@export var characters = {}
@export var all_characters = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	instantiate_characters()
	#instantiate_all_characters()
	#print(all_characters)
	#new_character()


func instantiate_characters() -> void:
	var initial_x: int = 60
	var initial_y: int = 470
	var addx: int = 185
	var addy: int = 100
	var max_per_row: int = 6
	var index: int = 0
	for z in json_char:
		if(json_char[z]["is_present"] == true):
			var character = character_scene.instantiate()
			character.name = json_char[z]["name"]
			character.name_ = json_char[z]["name"]
			character.sick = json_char[z]["sick"]
			character.is_present = json_char[z]["is_present"]
			character.dead = json_char[z]["dead"]
			var x = initial_x + (index % max_per_row) * addx
			var y = initial_y + (index / max_per_row) * addy
			#character.global_position = Vector2(x, y)
			character.emotions = {
				"normal": load(json_char[z]["images"]["normal"]),
				"sad": load(json_char[z]["images"]["sad"]),
				"happy": load(json_char[z]["images"]["happy"]),
				"angry": load(json_char[z]["images"]["angry"]),
			}
			#character.connect("companion_removed", Callable(self, "_on_companion_removed"))
			characters[character.name] = character
			index += 1
			character.initialize_character()
			
			

func instantiate_all_characters() -> void:
	var characters_array: Array = json_char.keys() # Ottenere tutti i personaggi
	characters_array.shuffle() # Mescolare l'array per ordine casuale

	var initial_x: int = 55
	var initial_y: int = 430
	var addx: int = 185
	var addy: int = 100
	var max_per_row: int = 9
	var index: int = 0

	for character_key in characters_array:
		var character_data = json_char[character_key]
		var character = character_scene.instantiate() # Si presume l'esistenza di un PackedScene per i personaggi
		character.name = character_data["name"]
		character.sick = character_data["sick"]
		character.is_present = character_data["is_present"]
		character.dead = character_data["dead"]
		var x = initial_x + (index % max_per_row) * addx
		var y = initial_y + (index / max_per_row) * addy
		character.global_position = Vector2(x, y)
		character.emotions = {
			"normal": load(character_data["images"]["normal"]),
			"sad": load(character_data["images"]["sad"]),
			"happy": load(character_data["images"]["happy"]),
			"angry": load(character_data["images"]["angry"]),
		}
		index += 1
		all_characters[character.name] = character

func new_character() -> void:
	characters[all_characters[all_characters.keys()[0]].name] = all_characters[all_characters.keys()[0]]
	characters[all_characters[all_characters.keys()[0]].name].initialize_character()
	all_characters.erase(all_characters.keys()[0])
	#TODO AGGIORNAMENTO E NOTIFICA DEL NUOVO PERSONAGGIO
	
func assign_sick(character, flag: bool) -> void:
	character.sick = flag
		
func assign_is_present(character, flag: bool) -> void:
	character.is_present = flag

func get_is_not_housed_list():
	var l = []
	for x in characters:
		if characters[x].is_housed == false and characters[x].is_present:
			l.append(characters[x])
	return l

func get_sick_list():
	var l = []
	for x in characters:
		if characters[x].sick == true and characters[x].is_present:
			l.append(characters[x])
	return l
