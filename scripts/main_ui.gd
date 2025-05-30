extends Control

func _ready():
	Globals.load_settings()
	$VBoxContainer/MenuBar.hide_edit()
	DisplayServer.window_set_title("Japko's Assistant AI - Main Menu", 0)

func _on_description_generator_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/sm_post_idea.tscn")

func _on_roleplay_generator_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/roleplay_gen.tscn")
	
func _on_character_creator_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/character_maker_interactive.tscn")
