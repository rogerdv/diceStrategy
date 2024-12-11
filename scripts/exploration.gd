extends Node2D


#Aggiunta di possibili  drop oggetti specifici personaggio
#aggiunta di 3 zone e 2 aggettivi


var zones: Dictionary = {
	"Forest" : {
		"danger_level": 2,
		"basic_loot" : {
			"high_rate" : [Enums.resources.WOOD],
			"medium_rate" : [Enums.resources.FOOD],
			"low_rate": [Enums.resources.STONE],
		},
		"special_loot": {
			Enums.resources.SAW : 10,
			Enums.resources.TRAP : 5,
			Enums.resources.PEOPLE : 2,
			Enums.resources.SICK_PEOPLE: 1
		}, 
	},
	"Hills" : {
		"danger_level": 2,
		"basic_loot" : {
			"high_rate" : [Enums.resources.WOOD, Enums.resources.FOOD],
			"medium_rate" : [],
			"low_rate" : [Enums.resources.STONE]
		},
		"special_loot": {
			Enums.resources.PEOPLE : 2,
			Enums.resources.SICK_PEOPLE: 1
		},  
	},
	"Cave" : {
		"danger_level": 2,
		"basic_loot" : {
			"high_rate" : [Enums.resources.WOOD, Enums.resources.FOOD],
			"medium_rate" : [],
			"low_rate" : [Enums.resources.STONE]
		},
		"special_loot": {
			Enums.resources.SICK_PEOPLE: 1,
			Enums.resources.MATCHES : 5,

		},  
	},
	"Ruins" : {
		"danger_level": 2,
		"basic_loot" : {
			"high_rate" : [Enums.resources.WOOD, Enums.resources.FOOD],
			"medium_rate" : [],
			"low_rate" : [Enums.resources.STONE]
		},
		"special_loot": {
			Enums.resources.PEOPLE : 5,
			Enums.resources.SICK_PEOPLE: 2,
			Enums.resources.PICKAXE : 2,
			Enums.resources.CART : 2,
		},  
	},
	"Lumber Mill" : {
		"danger_level": 4,
		"basic_loot" : {
			"high_rate" : [Enums.resources.WOOD],
			"medium_rate" : [Enums.resources.STONE, Enums.resources.WOOD],
			"low_rate" : [Enums.resources.FOOD, Enums.resources.WOOD]
		},
		"special_loot": {
			Enums.resources.CART : 5,
			Enums.resources.SAW : 25,
			Enums.resources.PEOPLE : 5,
		},  
	},
	"Mine" : {
		"danger_level": 6,
		"basic_loot" : {
			"high_rate" : [Enums.resources.STONE],
			"medium_rate" : [Enums.resources.STONE, Enums.resources.IRON, Enums.resources.COAL],
			"low_rate" : [Enums.resources.STONE, Enums.resources.COAL]
		},
		"special_loot": {
			Enums.resources.PICKAXE : 25,
			Enums.resources.CART : 5,
			Enums.resources.PEOPLE : 5,
		},
	},
	"Meadow" : {
		"danger_level": 1,
		"basic_loot" : {
			"high_rate" : [Enums.resources.FOOD],
			"medium_rate" : [Enums.resources.STONE, Enums.resources.FOOD],
			"low_rate" : [Enums.resources.FOOD, Enums.resources.WOOD]
		},
		"special_loot": {
			Enums.resources.PEOPLE : 2,
		},
	}
}

var adjectives: Dictionary = {
	"Frozen": {
		"available_zones" : [],
		"danger_level" : 2,
		"basic_loot" : {
			"high_rate": [],
			"medium_rate" : [],
			"low_rate" : []
		}
	},
	"Scary": {
		"available_zones" : ["Cave", "Ruins", "Mine"],
		"danger_level" : 4,
		"basic_loot" : {
			"high_rate": [],
			"medium_rate" : [],
			"low_rate" : []
		}
	},
	"Barren": {
		"available_zones" : ["Forest", "Hills"],
		"danger_level" : 2,
		"basic_loot" : {
			"high_rate": [],
			"medium_rate" : [],
			"low_rate" : []
		}
	},
	"Gloomy": {
		"available_zones" : ["Forest", "Hills", "Cave", "Ruins"],
		"danger_level" : 2,
		"basic_loot" : {
			"high_rate": [],
			"medium_rate" : [],
			"low_rate" : []
		}
	},
	"Forsaken": {
		"available_zones" : ["Ruins", "Lumber Mill", "Mine"],
		"danger_level" : 3,
		"basic_loot" : {
			"high_rate": [],
			"medium_rate" : [],
			"low_rate" : []
		}
	},
	"Foggy": {
		"available_zones" : ["Meadow", "Forest", "Hills"],
		"danger_level" : 2,
		"basic_loot" : {
			"high_rate": [],
			"medium_rate" : [],
			"low_rate" : []
		}
	},
	"Mysterious": {
		"available_zones" : [],
		"danger_level" : 0,
		"basic_loot" : {
			"high_rate": [],
			"medium_rate" : [],
			"low_rate" : []
		}
	}
}

var exploration_map: Dictionary = {}
var final_tree = []

func _ready():
	randomize()
	_add_misterious()
	exploration_map = _create_exploration_zones()
	final_tree = generate_tree_route(exploration_map)
	#print(final_tree)
	#print(len(exploration_map.keys()))
	
func _add_misterious() -> void: 
	var l = [Enums.resources.STONE, Enums.resources.COAL,  Enums.resources.IRON, Enums.resources.FOOD, Enums.resources.WOOD]
	adjectives["Mysterious"]["available_zones"] = zones.keys()
	adjectives["Mysterious"]["danger_level"] = randi() % 7 + 1
	for rate in adjectives["Mysterious"]["basic_loot"].keys():
		var loot_list = adjectives["Mysterious"]["basic_loot"][rate]
		var num_items = randi() % 3 + 1 
		while loot_list.size() < num_items:
			var item = l[randi() % l.size()]
			if not loot_list.has(item):
				loot_list.append(item)
	
func _create_exploration_zones():
	var exploration_zones = {}
	for zone_name in zones.keys():
		for adj_name in adjectives.keys():
			if zone_name in adjectives[adj_name]["available_zones"]:
				var combined_name = adj_name + " " + zone_name
				var combined_danger = zones[zone_name]["danger_level"] + adjectives[adj_name]["danger_level"]
				var combined_loot = _combine_loot(zones[zone_name]["basic_loot"], adjectives[adj_name]["basic_loot"])

				exploration_zones[combined_name] = {
					"danger_level": combined_danger,
					"loot": combined_loot
				}
	exploration_zones = _randomize_final_loot(exploration_zones)
	exploration_zones = _process_special_loot(exploration_zones)
	exploration_zones = add_travel_time(exploration_zones)
	return exploration_zones

func _combine_loot(zone_loot, adj_loot):
	var combined_loot = {"high_rate": [], "medium_rate": [], "low_rate": []}

	for rate in combined_loot.keys():
		var zone_items = zone_loot[rate] if rate in zone_loot else []
		var adj_items = adj_loot[rate] if rate in adj_loot else []
		var all_items = zone_items + adj_items
		var item_count = {}
		
		for item in all_items:
			if item:
				item_count[item] = item_count.get(item, 0) + 1

		for item in item_count.keys():
			var count = item_count[item]
			if count > 1:
				combined_loot["high_rate"].append(item)
			elif count == 1:
				combined_loot["medium_rate"].append(item)

	return combined_loot

func _process_special_loot(exploration_zones: Dictionary) -> Dictionary:

	for combined_zone_name in exploration_zones.keys():
		var zone_data = exploration_zones[combined_zone_name]
		var original_zone_name = get_original_zone_name(combined_zone_name)
		if original_zone_name in zones:
			var special_loot = zones[original_zone_name].get("special_loot", {})
			var final_special_loot = {}

			for item in special_loot.keys():
				var chance = special_loot[item]
				var roll = randi() % 100 + 1  # Genera un numero da 1 a 100
				final_special_loot[item] = roll <= chance  # True se l'oggetto è presente, False altrimenti

			zone_data["special_loot_present"] = final_special_loot

	return exploration_zones

func get_original_zone_name(combined_zone_name: String) -> String:
	var parts = combined_zone_name.split(" ")
	return parts[parts.size() - 1]



func _randomize_final_loot(exploration_zones: Dictionary):
	for zone_name in exploration_zones.keys():
		var final_loot = {}
		var zone_loot = exploration_zones[zone_name]["loot"]

		for rate_category in zone_loot.keys():
			var items = zone_loot[rate_category]
			for item in items:
				var random_value = _get_random_value_for_rate(rate_category)
				if final_loot.has(item):
					final_loot[item] += random_value  # Somma i valori se l'elemento è già presente
				else:
					final_loot[item] = random_value

		exploration_zones[zone_name]["final_loot"] = final_loot
	return exploration_zones


func add_travel_time(exploration_zones: Dictionary):
	for x in exploration_zones:
		exploration_zones[x]["distance"] = randi() % 5 + 1
	return exploration_zones

func _remove_whitespace(string):
	var new_string = ""
	for i in range(string.length()):
		if string[i] != ' ':
			new_string += string[i]
	return new_string

func _get_random_value_for_rate(rate_category: String) -> int:
	match rate_category:
		"low_rate":
			return randi() % 6 
		"medium_rate":
			return 4 + randi() % 7  
		"high_rate":
			return 9 + randi() % 7 
	return 0


# Funzione per selezionare un sottoinsieme casuale di chiavi dal dizionario dei percorsi
func select_casual_route(exploration_zones: Dictionary, _min: int, _max: int) -> Array:
	var k = exploration_zones.keys()
	var sel_route = []
	var n_route = randi_range(_min, _max) # Numero casuale di percorsi da selezionare
	
	while sel_route.size() < n_route:
		var rand_k = k[randi_range(0, k.size() - 1)]
		if not sel_route.has(rand_k):
			sel_route.append(rand_k)
	
	return sel_route

# Funzione per costruire un albero di percorsi
func build_tree(sel_route: Array) -> Dictionary:
	var tree = {}
	var used_routes = []
	
	# Inizializza l'albero con un percorso radice casuale
	var root = sel_route[randi_range(0, sel_route.size() - 1)]
	tree[root] = []
	used_routes.append(root)
	
	# Costruisce rami casualmente
	for route in sel_route:
		if route in used_routes:
			continue
		var random_branch = used_routes[randi_range(0, used_routes.size() - 1)]
		if tree.has(random_branch):
			tree[random_branch].append(route)
		else:
			tree[random_branch] = [route]
		used_routes.append(route)
	
	return tree

# Funzione principale per generare l'albero di percorsi
func generate_tree_route(exploration_zones: Dictionary):
	randomize() # Assicura che i numeri casuali siano diversi ad ogni esecuzione
	var random_route = select_casual_route(exploration_zones, 10, 12)
	var tree = build_tree(random_route)
	return tree
