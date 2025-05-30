extends Node

class_name AboutSummoner

@onready var about_screen = preload("res://scenes/about.tscn")

func summon_about():
	var window = Window.new()
	get_node("../").add_child(window)
	window.name = "About"
	window.title = "About Japko's Assistant AI..."
	window.popup()
