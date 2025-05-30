extends Control

@onready var json_module = JsonModule.new()
@onready var outputbox = $VBoxContainer/Panel/HSplitContainer/OutputBox
@onready var inputbox = $VBoxContainer/Panel/HSplitContainer/InputBox

@onready var nobodywhomodule = preload("res://nobodywhomodule.tscn")

var prompt = ""
var audio_track_in = "Forget previous output and generate a simple description for YouTube Music Video which will be used as a description. Output only the description without any explanations. Do not insert header with artists, vocalists and track title or album title. Here's info that user provided: "
var social_media_in = "Generate a text for social media post. Output only the description without any explanations. Here's info that user provided: "

func disable_buttons():
	$VBoxContainer/Panel/Generate.disabled = true
	$VBoxContainer/Panel/Generate.text = "Generating..."
	$VBoxContainer/Panel/MainMenu.disabled = true
	
func enable_buttons():
	$VBoxContainer/Panel/Generate.disabled = false
	$VBoxContainer/Panel/Generate.text = "Generate"
	if outputbox.text != "" and $VBoxContainer/Panel/PromptSelection.text == "Audio Track Description":
		json_module.load_sysprompt("prompts/mv_suffix.json")
		outputbox.text += "\n\n" + json_module.systemprompt
	$VBoxContainer/Panel/MainMenu.disabled = false

func update_prompt():
	if $VBoxContainer/Panel/PromptSelection.text == "Social Media Post":
		json_module.load_sysprompt("prompts/socialmedia_statement.json")
		$Nobodywhomodule.systemprompt = json_module.systemprompt
		$Nobodywhomodule.set_systemprompt()
		prompt = social_media_in
	elif $VBoxContainer/Panel/PromptSelection.text == "Audio Track Description":
		json_module.load_sysprompt("prompts/mv_description.json")
		$Nobodywhomodule.systemprompt = json_module.systemprompt
		$Nobodywhomodule.set_systemprompt()
		prompt = audio_track_in
	print($Nobodywhomodule.systemprompt)
	
func _ready():
	update_prompt()
	load_settings()
	DisplayServer.window_set_title("Japko's Assistant AI - Description Generator", 0)

func _on_generate_pressed() -> void:
	$Nobodywhomodule.context_reset()
	$Nobodywhomodule.seed_randomize()
	$Nobodywhomodule.say(prompt + inputbox.text)
	outputbox.text = ""
	disable_buttons()

func _on_prompt_selection_item_selected(index: int) -> void:
	update_prompt()

func _on_main_menu_pressed() -> void:
	$Nobodywhomodule.queue_free()
	get_tree().change_scene_to_file("res://scenes/main_ui.tscn")

func _on_restart_ai_pressed() -> void:
	$Nobodywhomodule.queue_free()
	$VBoxContainer/Panel/RestartAI.disabled = true
	disable_buttons()
	await get_tree().create_timer(3).timeout
	var new = nobodywhomodule.instantiate()
	self.add_child(new)
	new.name = "Nobodywhomodule"
	outputbox.text = ""
	await get_tree().create_timer(1.5).timeout
	enable_buttons()
	$VBoxContainer/Panel/RestartAI.disabled = false

func load_settings():
	outputbox.add_theme_font_size_override("font_size", Globals.settings_font_size)
	inputbox.add_theme_font_size_override("font_size", Globals.settings_font_size)
