extends Node

const ActionScenePath: String = "res://action/action.tscn"
var action_scene = preload(ActionScenePath)


@export var actions = {
	Enums.action_categories.RESOURCES: {},
	Enums.action_categories.HUNTING: {},
	Enums.action_categories.BUILDING: {},
	Enums.action_categories.TOOLS: {},
	Enums.action_categories.OTHER: {},
	Enums.action_categories.REPAIR: {},
} 

@export var action_map = {
	Enums.resources.OVEN: {
		"build_action": Enums.action_types.BUILD_OVEN,
		"repair_action": Enums.action_types.REPAIR_OVEN,
	},
	Enums.resources.BIG_OVEN: {
		"build_action": Enums.action_types.BUILD_BIG_OVEN,
		"repair_action": Enums.action_types.REPAIR_BIG_OVEN
	},
	Enums.resources.FENCES: {
		"build_action": Enums.action_types.BUILD_FENCES,
		"repair_action": Enums.action_types.REPAIR_FENCES
	},

}

@export var match_action_resource = {
	Enums.action_types.BUILD_OVEN: Enums.resources.OVEN,
	Enums.action_types.BUILD_BIG_OVEN: Enums.resources.BIG_OVEN,
	Enums.action_types.BUILD_FENCES: Enums.resources.FENCES,
	Enums.action_types.BUILD_BONFIRE_COVER: Enums.resources.BONFIRE_COVER,
	Enums.action_types.BUILD_WAREHOUSE: Enums.resources.WAREHOUSE,
	Enums.action_types.BUILD_BIG_WAREHOUSE: Enums.resources.BIG_WAREHOUSE,
	Enums.action_types.BUILD_SAW: Enums.resources.SAW,
	Enums.action_types.BUILD_PICKAXE: Enums.resources.PICKAXE,
	Enums.action_types.BUILD_CART: Enums.resources.CART,
	Enums.action_types.BUILD_ARROW: Enums.resources.ARROW,
	Enums.action_types.BUILD_BONFIRE: Enums.resources.BONFIRE,
	Enums.action_types.BUILD_BOW: Enums.resources.BOW,
	Enums.action_types.BUILD_TRAP: Enums.resources.TRAP,
	Enums.action_types.BUILD_SPEAR: Enums.resources.SPEAR,
}

var json_actions = {
	"wood_harvesting": {
		"category": Enums.action_categories.RESOURCES,
		"type":Enums.action_types.WOOD_HARVESTING,
		"description": "Gathering wood from trees or logs, using tools like axes.",
		"x": 110,
		"y": 200,
		"disabled": false,
		"total_limit": 999,
		"daily_limit": 999,
		"craft": false,
	},
	"fiber_harvesting": {
		"category": Enums.action_categories.RESOURCES,
		"type":Enums.action_types.FIBER_HARVESTING,
		"description": "Gathering FIBER",
		"x": 330,
		"y": 200,
		"disabled": false,
		"total_limit": 999,
		"daily_limit": 999,
		"craft": false,
	},
	"food_harvesting": {
		"category": Enums.action_categories.RESOURCES,
		"type":Enums.action_types.FOOD_HARVESTING,
		"description": "Collecting edible plants, fruits, or other food resources from the environment.",
		"x": 550,
		"y": 200,
		"disabled": false,
		"total_limit": 999,
		"daily_limit": 999,
		"craft": false,
	},
	"stone_harvesting": {
		"category": Enums.action_categories.RESOURCES,
		"type":Enums.action_types.HARVESTING_STONE,
		"description": "Extracting stone materials, possibly for construction or tool-making.",
		"x": 770,
		"y": 200,
		"disabled": false,
		"total_limit": 999,
		"daily_limit": Resources.resources[Enums.resources.PICKAXE],
		"craft": false,
	},
	"coal_harvesting": {
		"category": Enums.action_categories.RESOURCES,
		"type":Enums.action_types.HARVESTING_COAL,
		"description": "Obtaining carbon-based resources, potentially for fuel or crafting.",
		"x": 990,
		"y": 200,
		"disabled": false,
		"total_limit": 999,
		"daily_limit": Resources.resources[Enums.resources.PICKAXE],
		"craft": false,
	},
	"make_charcoal": {
		"category": Enums.action_categories.RESOURCES,
		"type":Enums.action_types.MAKE_CHARCOAL,
		"description": "Making charcoal from wood",
		"x": 110,
		"y": 300,
		"disabled": false,
		"total_limit": 999,
		"daily_limit": Resources.resources[Enums.resources.PICKAXE],
		"craft": false,
	},
	"hunt_no_weapons": {
		"category": Enums.action_categories.HUNTING,
		"type":Enums.action_types.HUNT_NO_WEAPONS,
		"description": "Hunting animals without the use of any tools or weapons.",
		"x": 110,
		"y": 200,
		"disabled": false,
		"total_limit": 999,
		"daily_limit": 999,
		"craft": false,
	},
	"hunt_with_spear": {
		"category": Enums.action_categories.HUNTING,
		"type":Enums.action_types.HUNT_WITH_SPEAR,
		"description": "Hunt with spear",
		"x": 330,
		"y": 200,
		"disabled": false,
		"total_limit": 999,
		"daily_limit": 999,
		"craft": false,
	},
	"hunt_with_bow": {
		"category": Enums.action_categories.HUNTING,
		"type":Enums.action_types.HUNT_WITH_BOW,
		"description": "Hunt with bow",
		"x": 550,
		"y": 200,
		"disabled": false,
		"total_limit": 999,
		"daily_limit": 999,
		"craft": false,
	},
	"hunt_with_trap": {
		"category": Enums.action_categories.HUNTING,
		"type":Enums.action_types.HUNT_WITH_TRAP,
		"description": "Hunt with trap",
		"x": 770,
		"y": 200,
		"disabled": false,
		"total_limit": 999,
		"daily_limit": 999,
		"craft": false,
	},
	"build_improvised_shelter": {
		"category": Enums.action_categories.BUILDING,
		"type": Enums.action_types.BUILD_IMPROVISED_SHELTER,
		"description": "Build Improvised Shelter",
		"x": 110,
		"y": 200,
		"disabled": true,
		"total_limit": 999,
		"daily_limit": 999,
		"craft": true,
		"resources_needed": {
			"wood": 1,
			"fiber": 1,
		},
		"manpower": 3,
	},
	"build_simple_refuge": {
		"category": Enums.action_categories.BUILDING,
		"type": Enums.action_types.BUILD_SIMPLE_REFUGE,
		"description": "Build simple refuge",
		"x": 330,
		"y": 200,
		"disabled": true,
		"total_limit": 999,
		"daily_limit": 999,
		"craft": true,
		"resources_needed": {
			"wood": 1,
			"stone": 1,
			"fiber": 1,
		},
		"manpower": 5,
	},
	"build_bonfire_cover": {
		"category": Enums.action_categories.BUILDING,
		"type": Enums.action_types.BUILD_BONFIRE_COVER,
		"description": "Build bonfire cover",
		"x": 550,
		"y": 200,
		"disabled": true,
		"total_limit": 1,
		"daily_limit": 1,
		"craft": true,
		"resources_needed": {
			"wood": 1,
			"stone": 1,
			"fiber": 1,
		},
		"manpower": 1,
	},
	"build_simple_house": {
		"category": Enums.action_categories.BUILDING,
		"type": Enums.action_types.BUILD_SIMPLE_HOUSE,
		"description": "Build simple house",
		"x": 770,
		"y": 200,
		"disabled": true,
		"total_limit": 999,
		"daily_limit": 999,
		"craft": true,
		"resources_needed": {
			"wood": 1,
			"stone": 1
		},
		"manpower": 9,
		
	},
	"build_oven": {
		"category": Enums.action_categories.BUILDING,
		"type": Enums.action_types.BUILD_OVEN,
		"description": "Build Oven",
		"x": 990,
		"y": 200,
		"disabled": true,
		"total_limit": 999,
		"daily_limit": 999,
		"craft": true,
		"resources_needed": {
			"wood": 1,
			"stone": 1
		},
		"manpower": 6,
	},
	"build_big_oven": {
		"category": Enums.action_categories.BUILDING,
		"type": Enums.action_types.BUILD_BIG_OVEN,
		"description": "Build Big Oven",
		"x": 110,
		"y": 300,
		"disabled": true,
		"total_limit": 999,
		"daily_limit": 999,
		"craft": true,
		"resources_needed": {
			"wood": 1,
			"stone": 1
		},
		"manpower": 10,
	},
	"build_warehouse": {
		"category": Enums.action_categories.BUILDING,
		"type": Enums.action_types.BUILD_WAREHOUSE,
		"description": "Build Warehouse",
		"x": 330,
		"y": 300,
		"disabled": true,
		"total_limit": 999,
		"daily_limit": 999,
		"craft": true,
		"resources_needed": {
			"wood": 1,
			"stone": 1
		},
		"manpower": 8,
	},
	"build_big_warehouse": {
		"category": Enums.action_categories.BUILDING,
		"type": Enums.action_types.BUILD_BIG_WAREHOUSE,
		"description": "Build Big Warehouse",
		"x": 550,
		"y": 300,
		"disabled": true,
		"total_limit": 999,
		"daily_limit": 999,
		"craft": true,
		"resources_needed": {
			"wood": 1,
			"stone": 1
		},
		"manpower": 12,
	},
	"build fences": {
		"category": Enums.action_categories.BUILDING,
		"type": Enums.action_types.BUILD_FENCES,
		"description": "Build fences",
		"x": 770,
		"y": 300,
		"disabled": true,
		"total_limit": 3,
		"daily_limit": 3,
		"craft": true,
		"resources_needed": {
			"wood": 1,
		},
		"manpower": 3,
	},
	"craft_pickaxe": {
		"category": Enums.action_categories.TOOLS,
		"type": Enums.action_types.BUILD_PICKAXE,
		"description": "Build Pickaxe",
		"x": 110,
		"y": 200,
		"disabled": true,
		"total_limit": 999,
		"daily_limit": 999,
		"craft": true,
		"resources_needed": {
			"wood": 1,
			"stone": 1,
			"fiber": 1,
		}
	},
	"craft_saw": {
		"category": Enums.action_categories.TOOLS,
		"type": Enums.action_types.BUILD_SAW,
		"description": "Build Saw",
		"x": 330,
		"y": 200,
		"disabled": true,
		"total_limit": 999,
		"daily_limit": 999,
		"craft": true,
		"resources_needed": {
			"wood": 1,
			"stone": 1,
			"fiber": 1,
		}
	},
	"craft_cart": {
		"category": Enums.action_categories.TOOLS,
		"type": Enums.action_types.BUILD_CART,
		"description": "Build Cart",
		"x": 550,
		"y": 200,
		"disabled": true,
		"total_limit": 999,
		"daily_limit": 999,
		"craft": true,
		"resources_needed": {
			"wood": 1,
			"stone": 1
		}
	},
	"craft_spear": {
		"category": Enums.action_categories.TOOLS,
		"type": Enums.action_types.BUILD_SPEAR,
		"description": "Build Spear",
		"x": 770,
		"y": 200,
		"disabled": true,
		"total_limit": 999,
		"daily_limit": 999,
		"craft": true,
		"resources_needed": {
			"wood": 1,
			"stone": 1,
			"fiber": 1,
		}
	},
	"craft_bow": {
		"category": Enums.action_categories.TOOLS,
		"type": Enums.action_types.BUILD_BOW,
		"description": "Build Bow",
		"x": 990,
		"y": 200,
		"disabled": true,
		"total_limit": 999,
		"daily_limit": 999,
		"craft": true,
		"resources_needed": {
			"wood": 1,
			"stone": 1,
			"fiber": 1,
		}
	},
	"craft_bonfire": {
		"category": Enums.action_categories.TOOLS,
		"type": Enums.action_types.BUILD_BONFIRE,
		"description": "Build Bonfire",
		"x": 110,
		"y": 300,
		"disabled": true,
		"total_limit": 999,
		"daily_limit": 999,
		"craft": true,
		"resources_needed": {
			"wood": 1,
			"stone": 1
		}
	},
	"improve_bonfire": {
		"category": Enums.action_categories.TOOLS,
		"type": Enums.action_types.IMPROVE_BONFIRE,
		"description": "Improve Bonfire",
		"x": 330,
		"y": 300,
		"disabled": true,
		"total_limit": 999,
		"daily_limit": 999,
		"craft": true,
		"resources_needed": {
			"wood": 1,
			"stone": 1
		},
		"consumes_dice": false,
	},
	"craft_arrow": {
		"category": Enums.action_categories.TOOLS,
		"type": Enums.action_types.BUILD_ARROW,
		"description": "Build Arrow",
		"x": 550,
		"y": 300,
		"disabled": true,
		"total_limit": 999,
		"daily_limit": 999,
		"craft": true,
		"resources_needed": {
			"wood": 1,
			"stone": 1
		}
	},
	"craft_trap": {
		"category": Enums.action_categories.TOOLS,
		"type": Enums.action_types.BUILD_TRAP,
		"description": "Build trap",
		"x": 550,
		"y": 300,
		"disabled": true,
		"total_limit": 999,
		"daily_limit": 999,
		"craft": true,
		"resources_needed": {
			"wood": 1,
			"fiber": 1,
			"food": 1,
		}
	},
	"helping_hand": {
		"category": Enums.action_categories.OTHER,
		"type": Enums.action_types.HELPING_HAND,
		"description": "Helping Hand",
		"x": 110,
		"y": 200,
		"disabled": false,
		"total_limit": 999,
		"daily_limit": 1,
		"craft": false,
	},
	"stand_guard": {
		"category": Enums.action_categories.OTHER,
		"type": Enums.action_types.STAND_GUARD,
		"description": "Build Saw",
		"x": 330,
		"y": 200,
		"disabled": false,
		"total_limit": 999,
		"daily_limit": 1,
		"craft": false
	},
	"quick_nap": {
		"category": Enums.action_categories.OTHER,
		"type": Enums.action_types.QUICK_NAP,
		"description": "take a quick nap",
		"x": 550,
		"y": 200,
		"disabled": false,
		"total_limit": 999,
		"daily_limit": 1,
		"craft": false
	},
	"inspiring_speech": {
		"category": Enums.action_categories.OTHER,
		"type": Enums.action_types.INSPIRING_SPEECH,
		"description": "Give an inspiring speech",
		"x": 770,
		"y": 200,
		"disabled": false,
		"total_limit": 999,
		"daily_limit": 1,
		"craft": false
	},
	"training": {
		"category": Enums.action_categories.OTHER,
		"type": Enums.action_types.TRAINING,
		"description": "Get some training",
		"x": 990,
		"y": 200,
		"disabled": false,
		"total_limit": 999,
		"daily_limit": 1,
		"craft": false
	},
	"Rest": {
		"category": Enums.action_categories.OTHER,
		"type": Enums.action_types.REST,
		"description": "Give an inspiring speech",
		"x": 110,
		"y": 300,
		"disabled": false,
		"total_limit": 999,
		"daily_limit": 999,
		"craft": false
	},
	"repair_bonfire_cover": {
		"category": Enums.action_categories.REPAIR,
		"type": Enums.action_types.REPAIR_BONFIRE_COVER,
		"description": "Repair bonfire cover",
		"x": 550,
		"y": 200,
		"disabled": true,
		"total_limit": 1,
		"daily_limit": 1,
		"craft": true,
		"resources_needed": {
			"wood": 1,
			"stone": 1,
			"fiber": 1,
		},
		"manpower": 1,
	},
	"repair_oven": {
		"category": Enums.action_categories.REPAIR,
		"type": Enums.action_types.REPAIR_OVEN,
		"description": "Repair Oven",
		"x": 990,
		"y": 200,
		"disabled": true,
		"total_limit": 1,
		"daily_limit": 1,
		"craft": true,
		"resources_needed": {
			"wood": 1,
			"stone": 1
		},
		"manpower": 2,
	},
	"repair_big_oven": {
		"category": Enums.action_categories.REPAIR,
		"type": Enums.action_types.REPAIR_BIG_OVEN,
		"description": "Build Big Oven",
		"x": 110,
		"y": 300,
		"disabled": true,
		"total_limit": 1,
		"daily_limit": 1,
		"craft": true,
		"resources_needed": {
			"wood": 1,
			"stone": 1
		},
		"manpower": 4,
	},
	"repair_fences": {
		"category": Enums.action_categories.REPAIR,
		"type": Enums.action_types.REPAIR_FENCES,
		"description": "Repair fences",
		"x": 770,
		"y": 300,
		"disabled": true,
		"total_limit": 1,
		"daily_limit": 1,
		"craft": true,
		"resources_needed": {
			"wood": 1,
		},
		"manpower": 1,
	},
}


func _ready():
	#instantiate_action()
	#update_actions_resources()
	pass

func instantiate_action() -> void:
	for x in json_actions:
		var action_instance = action_scene.instantiate()
		action_instance.action_name = x
		action_instance.action_type = json_actions[x]['type']
		if action_instance.action_type == Enums.action_types.IMPROVE_BONFIRE:
			action_instance.consumes_dice = false
		action_instance.custom_text = json_actions[x]['description']
		action_instance.tot_limit = json_actions[x]['total_limit']
		action_instance.fixed_daily_limit = json_actions[x]['daily_limit']
		#action_instance.global_position = Vector2(json_actions[x]['x'], json_actions[x]['y'])
		action_instance.craft = json_actions[x]["craft"]
		if json_actions[x]['disabled']:
			action_instance.disable()
		if action_instance.craft:
			action_instance.resources_needed = json_actions[x]['resources_needed']
		actions[json_actions[x]["category"]][json_actions[x]["type"]] = action_instance
		if json_actions[x]["category"] == Enums.action_categories.BUILDING:
			action_instance.manpower = json_actions[x]['manpower']
			action_instance.manpower_fixed = json_actions[x]['manpower']
		
func get_repairs():
	return actions[Enums.action_categories.REPAIR]
	
func update_actions_resources() -> void:
	var limit = Resources.get_limit()
	
	var x = actions[Enums.action_categories.RESOURCES]
	for y in x:
		match x[y].action_type:
			Enums.action_types.WOOD_HARVESTING:
				if Resources.resources[Enums.resources.WOOD] == limit:
					x[y].disable()
			Enums.action_types.FOOD_HARVESTING:
				if Resources.resources[Enums.resources.FOOD] == limit:
					x[y].disable()
			Enums.action_types.MAKE_CHARCOAL, Enums.action_types.HARVESTING_COAL:
				if Resources.resources[Enums.resources.COAL] == limit:
					x[y].disable()
			Enums.action_types.HARVESTING_STONE:
				if Resources.resources[Enums.resources.STONE] == limit:
					x[y].disable()
			Enums.action_types.HARVESTING_IRON:
				if Resources.resources[Enums.resources.IRON] == limit:
					x[y].disable()
