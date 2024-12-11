extends Node

signal resource_updated(resource_name, new_value)

enum random_events{
	QUIET_NIGHT,
	ICY_NIGHT,
	COLD_NIGHT,
	MILD_NIGHT,
	HOT_NIGHT,
	NIGHT_ATTACK,
	VICIOUS_NIGHT_ATTACK,
	DEVASTATING_NIGHT_ATTACK,
	UNEXPECTED_VISITOR,
	UNEXPECTED_BOUNTY,
	UNEXPECTED_MIRACLE,
	UNEXPECTED_RESOURCES,
	STORYTELLING_AROUND_THE_FIRE,
	DREAMS_STAR_CAUGHT
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
	random_events.DEVASTATING_NIGHT_ATTACK: {
		"title": "Devastating Night Attack",
		"description": "A massive force has overwhelmed your defenses under the cover of darkness. A significant portion of your resources has been plundered."
	},
	random_events.UNEXPECTED_VISITOR: {
		"title": "Unexpected Visitor",
		"description": "Someone has come to your camp tonight, they needed a refuge"
	},
	random_events.UNEXPECTED_RESOURCES: {
		"title": "Unexpected Resources",
		"description": "Someone left some resources in your camp, what luck!"
	},
	random_events.UNEXPECTED_BOUNTY: {
		"title": "Unexpected bounty",
		"description": "Someone left some resources in your camp, what luck!"
	},
	random_events.UNEXPECTED_MIRACLE: {
		"title": "Unexpected miracle",
		"description": "Someone left some resources in your camp, what luck!"
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
		
var events = []

func _ready():
	pass

func quiet_night_event() -> void:
	pass

func icy_night_event() -> void:
	Resources.resources[Enums.resources.TEMPERATURE] -= 3
	emit_signal("resource_updated", "temperature", Resources.resources[Enums.resources.TEMPERATURE])

func cold_night_event() -> void:
	Resources.temperature -= 1
	emit_signal("resource_updated", "temperature", Resources.resources[Enums.resources.TEMPERATURE])
	
func mild_nigh_event() -> void:
	Resources.temperature += 1
	emit_signal("resource_updated", "temperature", Resources.resources[Enums.resources.TEMPERATURE])
	
func hot_night_event() -> void:
	Resources.temperature += 3
	emit_signal("resource_updated", "temperature", Resources.resources[Enums.resources.TEMPERATURE])

func night_attack_event() -> void:
	if Resources.resources[Enums.resources.FENCES]:
		var roll = randi() % 100 + 1
		if roll > 60:
			Resources.apply_resource_deduction(1)
			return
		else:
			return
	Resources.apply_resource_deduction(1)

func vicious_night_attack() -> void:
	if Resources.resources[Enums.resources.FENCES]:
		var roll = randi() % 100 + 1
		if roll > 50:
			Resources.apply_resource_deduction(1)
			return

	Resources.apply_resource_deduction(2)
	
func devastating_night_attack() -> void:
	if Resources.resources[Enums.resources.FENCES]:
		var roll = randi() % 100 + 1
		if roll > 80:
			Resources.apply_resource_deduction(2)
			return
		elif roll < 20:
			Resources.apply_resource_deduction(2)
			
	Resources.apply_resource_deduction(3)

func unexpected_visitor() -> void:
	CharacterManager.new_character()
	
func unexpected_resources() -> void:
	Resources.apply_resource_increase(1)

func unexpected_bounty() -> void:
	Resources.apply_resource_increase(2)

func unexpected_miracle() -> void:
	Resources.apply_resource_increase(3)

func storytelling_around_the_fire() -> void:
	pass
	#probabilità del 20% di essere boostato, creare altri eventi con una percentuale diversa e dipendenti da certi personaggi specifici
	
func dreams_star_caught() -> void: 
	pass
	#implementazione fortuna
