extends Node2D

@onready var tab_container = $TabContainer
@onready var tabs = {
	"Resources": $TabContainer/Resources,
	"Hunting": $TabContainer/Hunting,
	"Building": $TabContainer/Building,
	"Tools": $TabContainer/Tools,
	"Other": $TabContainer/Other,
	"Repair": $TabContainer/Repair
}

@export var actual_tab = 0

func _ready():
	Resources.connect("building_repaired", _on_building_repaired)
	Resources.connect("building_destroyed", _on_building_destroyed)
	hide_all_tabs()
	show_tab(tab_container.get_tab_title(0))


func enable_repair(name):
	for child in tabs["Repair"].get_children():
		if child.name == name:
			var action = child.get_child(0)
			print(action)
			action.enable()
			action.tot_limit = 1
			action.daily_limit = 1
			return 
	print("Nodo non trovato: %s" % name)

func disable_repair(name):
	for child in tabs["Repair"].get_children():
		if child.name == name:
			var action = child.get_child(0)
			print(action)
			action.disable()
			action.tot_limit = 0
			action.daily_limit = 0
			return 
	print("Nodo non trovato: %s" % name)

func _on_building_destroyed(destroyed_building):
	match destroyed_building:
		Enums.resources.OVEN: enable_repair("repair_oven")
		Enums.resources.BIG_OVEN: enable_repair("repair_big_oven")
		Enums.resources.FENCES: enable_repair("repair_fences")
		Enums.resources.BONFIRE_COVER: enable_repair("repair_bonfire_cover")


func _on_building_repaired(repaired_building):
	match repaired_building:
		Enums.resources.OVEN: disable_repair("repair_oven")
		Enums.resources.BIG_OVEN: disable_repair("repair_big_oven")
		Enums.resources.FENCES: disable_repair("repair_fences")
		Enums.resources.BONFIRE_COVER: disable_repair("repair_bonfire_cover")

func _set_daily_limits_for_children(parent_node):
	for child in parent_node.get_children():
		var first_child = child.get_child(0)
		if first_child and first_child.has_method("has") and first_child.has("fixed_daily_limit"):
			first_child.daily_limit = first_child.fixed_daily_limit

func _refresh_daily_limit():
	_set_daily_limits_for_children(tabs["Resources"])
	_set_daily_limits_for_children(tabs["Hunting"])
	_set_daily_limits_for_children(tabs["Building"])
	_set_daily_limits_for_children(tabs["Tools"])
	_set_daily_limits_for_children(tabs["Other"])


var pressed = false
func _on_settings_button_pressed():
	_refresh_daily_limit()
	if pressed == false:
		print("distrutto")
		pressed = true
		Resources.test_destroy()
	else:
		print("riparato")
		Resources.test_repair()
		
func _on_tab_container_tab_changed(tab_index):
	actual_tab = tab_index
	hide_all_tabs()
	show_tab(tab_container.get_tab_title(tab_index))

func hide_all_tabs():
	for tab in tabs.values():
		hide_tab_actions(tab)

func hide_tab_actions(tab):
	print(tab.get_children())
	for child in tab.get_children():
		child.get_child(0).hide_action()

func show_tab(tab_name):
	var tab = tabs[tab_name]
	for child in tab.get_children():
		child.get_child(0).show_action()
