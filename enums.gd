extends Node

@export var x: action_types

enum action_types {
	#Resources
	WOOD_HARVESTING,
	FIBER_HARVESTING,
	FOOD_HARVESTING,
	MAKE_CHARCOAL,
	HARVESTING_STONE,
	HARVESTING_COAL,
	HARVESTING_IRON,
	
	EXPLORATION,
	#Hunting
	HUNT_NO_WEAPONS,
	HUNT_WITH_SPEAR,
	HUNT_WITH_BOW,
	HUNT_WITH_TRAP,
	#Buildings
	BUILD_IMPROVISED_SHELTER,
	BUILD_SIMPLE_REFUGE,
	BUILD_SIMPLE_HOUSE,
	BUILD_OVEN,
	BUILD_BIG_OVEN,
	BUILD_WAREHOUSE,
	BUILD_BIG_WAREHOUSE,
	BUILD_FENCES,
	BUILD_BONFIRE_COVER,
	
	#Repair
	REPAIR_OVEN,
	REPAIR_BIG_OVEN,
	REPAIR_FENCES,
	REPAIR_BONFIRE_COVER,
	
	#Tools
	BUILD_SPEAR,
	BUILD_BOW,
	BUILD_ARROW,
	BUILD_TRAP,
	BUILD_SAW,
	BUILD_PICKAXE,
	BUILD_CART,
	BUILD_BONFIRE,
	IMPROVE_BONFIRE,
	#OTHER
	HELPING_HAND,
	STAND_GUARD,
	QUICK_NAP,
	INSPIRING_SPEECH,
	TRAINING,
	REST
	
}

enum action_categories { #MANPOWER
	RESOURCES,
	HUNTING,
	BUILDING,
	TOOLS,
	OTHER,
	REPAIR
}

enum random_events{
	QUIET_NIGHT,
	ICY_NIGHT,
	COLD_NIGHT,
	MILD_NIGHT,
	HOT_NIGHT,
	NIGHT_ATTACK,
	VICIOUS_NIGHT_ATTACK,
	UNEXPECTED_VISITOR,
	UNEXPECTED_RESOURCES,
	STORM,
	STORYTELLING_AROUND_THE_FIRE,
	DREAMS_STAR_CAUGHT
}

enum resources {
	WOOD,
	FIBER,
	FOOD,
	STONE,
	IRON,
	TEMPERATURE,
	TEMPERATURE_MODIFIER,
	COAL,
	MATCHES,
	IMPROVISED_SHELTER,
	SIMPLE_REFUGE,
	SIMPLE_HOUSE,
	OVEN,
	BIG_OVEN,
	WAREHOUSE,
	BIG_WAREHOUSE,
	FENCES,
	SPEAR,
	BOW,
	ARROW,
	TRAP,
	SAW,
	PICKAXE,
	CART,
	BONFIRE,
	BONFIRE_ACTIVE,
	BONFIRE_COVER,
	PEOPLE,
	SICK_PEOPLE,
	BOOSTED_PEOPLE
}



@export var events_descriptions = {
	random_events.QUIET_NIGHT: {
		"title": "Quiet Night",
		"description": "Nothing happened"
	},
	random_events.ICY_NIGHT: {
		"title": "Icy Night",
		"description": "It was a very cold night, the temperature dropped a lot"
	},
	random_events.COLD_NIGHT: {
		"title": "Cold Night",
		"description": "It was a cold night, the temperature decreased"
	},
	random_events.MILD_NIGHT: {
		"title": "Mild Night",
		"description": "The temperature increases"
	},
	random_events.HOT_NIGHT: {
		"title": "Hot Night",
		"description": "The temperature increases a lot"
	},
	random_events.NIGHT_ATTACK: {
		"title": "Night Attack",
		"description": "Someone has stolen some of your resources!"
	},
	random_events.VICIOUS_NIGHT_ATTACK: {
		"title": "Vicious Night Attack",
		"description": "Someone has stolen some of your resources and destroyed some stuff!"
	},
	random_events.UNEXPECTED_VISITOR: {
		"title": "Unexpected Visitor",
		"description": "Someone has come to your camp tonight, they needed a refuge"
	},
	random_events.UNEXPECTED_RESOURCES: {
		"title": "Unexpected Resources",
		"description": "Someone left some resources in your camp, what luck!"
	},
	random_events.STORM: {
		"title": "Storm",
		"description": "There was a storm tonight, the temperature dropped slightly and some building may be broken"
	},
	random_events.STORYTELLING_AROUND_THE_FIRE: {
		"title": "Storytelling Around The Fire",
		"description": "All of you go around the fire to talk."
	},
	random_events.DREAMS_STAR_CAUGHT: {
		"title": "In your dreams, you caught a star",
		"description": "You feel lucky"
	},
}

enum jobs {
	DOCTOR, #diminuisce leggermente la probabilità di ammalarsi
	HUNTER, #aumenta dalla caccia, diminuisce leggermente probabilità di morte e tornare senza nulla
	LUMBERJACK, #Aumenta legna e conversione in carbone da legno
	BUILDER, #2 Manpower invece di 1
	MINER, #Aumenta roccia, carbone e ferro
	TOOLMAKER, #diminuisce riquisiti risorse per tools
}


@export var actions = {
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
	"food_harvesting": {
		"category": Enums.action_categories.RESOURCES,
		"type":Enums.action_types.FOOD_HARVESTING,
		"description": "Collecting edible plants, fruits, or other food resources from the environment.",
		"x": 330,
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
		"x": 550,
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
		"x": 770,
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
		"x": 990,
		"y": 200,
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
		"type": action_types.BUILD_IMPROVISED_SHELTER,
		"description": "Build Improvised Shelter",
		"x": 110,
		"y": 200,
		"disabled": true,
		"total_limit": 999,
		"daily_limit": 999,
		"craft": true,
		"resources_needed": {
			"wood": 1,
		}
	},
	"build_simple_refuge": {
		"category": Enums.action_categories.BUILDING,
		"type": action_types.BUILD_SIMPLE_REFUGE,
		"description": "Build simple refuge",
		"x": 330,
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
	"build_simple_house": {
		"category": Enums.action_categories.BUILDING,
		"type": action_types.BUILD_SIMPLE_HOUSE,
		"description": "Build simple house",
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
	"build_oven": {
		"category": Enums.action_categories.BUILDING,
		"type": action_types.BUILD_OVEN,
		"description": "Build Oven",
		"x": 770,
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
	"build_big_oven": {
		"category": Enums.action_categories.BUILDING,
		"type": action_types.BUILD_BIG_OVEN,
		"description": "Build Big Oven",
		"x": 990,
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
	"build_warehouse": {
		"category": Enums.action_categories.BUILDING,
		"type": action_types.BUILD_WAREHOUSE,
		"description": "Build Warehouse",
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
	"build_big_warehouse": {
		"category": Enums.action_categories.BUILDING,
		"type": action_types.BUILD_BIG_WAREHOUSE,
		"description": "Build Big Warehouse",
		"x": 330,
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
	"craft_pickaxe": {
		"category": Enums.action_categories.TOOLS,
		"type": action_types.BUILD_PICKAXE,
		"description": "Build Pickaxe",
		"x": 110,
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
	"craft_saw": {
		"category": Enums.action_categories.TOOLS,
		"type": action_types.BUILD_SAW,
		"description": "Build Saw",
		"x": 330,
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
	"craft_cart": {
		"category": Enums.action_categories.TOOLS,
		"type": action_types.BUILD_CART,
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
		"type": action_types.BUILD_SPEAR,
		"description": "Build Spear",
		"x": 770,
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
	"craft_bow": {
		"category": Enums.action_categories.TOOLS,
		"type": action_types.BUILD_BOW,
		"description": "Build Bow",
		"x": 990,
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
	"craft_bonfire": {
		"category": Enums.action_categories.TOOLS,
		"type": action_types.BUILD_BONFIRE,
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
		"type": action_types.IMPROVE_BONFIRE,
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
		}
	},
	"craft_arrow": {
		"category": Enums.action_categories.TOOLS,
		"type": action_types.BUILD_ARROW,
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
		"type": action_types.BUILD_TRAP,
		"description": "Build trap",
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
}


	




