extends Node

var icons = []
var music = null
enum Weather {
	SNOW,
	RAIN,
	SUNNY,
	STORM,
	CLOUDY,
	NORMAL
}

var probability_weather: Dictionary = {
	Weather.SNOW: 5,
	Weather.RAIN: 10,  # Base più bassa per "RAIN"
	Weather.SUNNY: 10,
	Weather.STORM: 5,  # Base più bassa per "STORM"
	Weather.CLOUDY: 12,
	Weather.NORMAL: 50,
}

var days_without_weather: int = 0
var days_weather_active: int = 0
@export var actual_weather: Weather = Weather.NORMAL # Initialize with default weather

func _ready():
	randomize() 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func random_weather():
	if actual_weather == Weather.NORMAL and days_without_weather > 3:
		var new_weather = randi() % (Weather.size() - 1) # Randomly select a weather type, excluding NORMAL
		if new_weather >= Weather.NORMAL: # If the random value is equal or greater than NORMAL's index, adjust to skip NORMAL
			new_weather += 1
		actual_weather = new_weather 
		days_without_weather = 0 


#metodo per ripristinare la temperatura corretta
func update_weather_effects():
	match actual_weather:
		Weather.SNOW:
			Resources.resources[Enums.resources.TEMPERATURE_MODIFIER] = -3
		Weather.RAIN:
			Resources.resources[Enums.resources.TEMPERATURE_MODIFIER] = -1
		Weather.SUNNY:
			Resources.resources[Enums.resources.TEMPERATURE_MODIFIER] = 2
		Weather.STORM:
			Resources.resources[Enums.resources.TEMPERATURE_MODIFIER] = -2
			on_storm_active()
		Weather.CLOUDY:
			Resources.resources[Enums.resources.TEMPERATURE_MODIFIER] = 0
		Weather.NORMAL:
			Resources.resources[Enums.resources.TEMPERATURE_MODIFIER] = 0

func update_weather() -> void:
	var previous_weather = actual_weather
	random_weather() # Aggiorna il `actual_weather` prima di aggiustare le probabilità
	
	# Reset delle probabilità a valori di base
	probability_weather[Weather.RAIN] = 10
	probability_weather[Weather.STORM] = 5

	if previous_weather == Weather.CLOUDY and actual_weather != Weather.RAIN:
		probability_weather[Weather.RAIN] += 15
	elif previous_weather == Weather.RAIN and actual_weather != Weather.STORM:
		probability_weather[Weather.STORM] += 10

	normalize_probabilities()

func normalize_probabilities():
	var total_prob = 0
	for weather in probability_weather:
		total_prob += probability_weather[weather]

	for weather in probability_weather:
		probability_weather[weather] = (probability_weather[weather] / total_prob) * 100


func on_sunny() -> void:
	pass

func on_rain_active() -> void:
	if !Resources.resources[Enums.resources.BONFIRE_COVER]:
		Resources.resources[Enums.resources.BONFIRE] = 0

func on_storm_active() -> void:
	Resources.destroy_building()

	if !Resources.resources[Enums.resources.BONFIRE_COVER]:
		Resources.resources[Enums.resources.BONFIRE] = 0
