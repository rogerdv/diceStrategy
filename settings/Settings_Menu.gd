class_name SettingsMenu

extends Control

@onready var exit = $MarginContainer/VBoxContainer/Exit as Button

signal exit_settings


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_exit_pressed():
	exit_settings.emit()
	set_process(false)
