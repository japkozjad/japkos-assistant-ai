extends Control

@onready var json_module = JsonModule.new()
@onready var outputbox = $VBoxContainer/Panel/HSplitContainer/OutputBox
@onready var inputbox = $VBoxContainer/Panel/InputBox

@onready var nobodywhomodule = preload("res://nobodywhomodule.tscn")
var prompt_path = "prompts/charactercreator_interactive.json"
var prev_text = ""

@onready var menu_button = $VBoxContainer/Panel/InputBox/MenuButton
@onready var popup_menu = menu_button.get_popup()

func _ready():
	DisplayServer.window_set_title("Japko's Assistant AI - Character Creator", 0)
	update_prompt()
	load_settings()
	popup_menu.id_pressed.connect(_on_menu_option_pressed)

func update_prompt():
	json_module.load_sysprompt(prompt_path)
	$Nobodywhomodule.systemprompt = json_module.systemprompt + "\nHere's a history chat with the user: " + outputbox.text
	$Nobodywhomodule.set_systemprompt()
	print("System prompt set to: " + $Nobodywhomodule/NobodyWhoChat.system_prompt)

func disable_buttons():
	$VBoxContainer/Panel/Generate.disabled = true
	$VBoxContainer/Panel/Generate.text = "Generating..."
	$VBoxContainer/Panel/MainMenu.disabled = true
	inputbox.editable = false
	
func enable_buttons():
	$VBoxContainer/Panel/Generate.disabled = false
	$VBoxContainer/Panel/Generate.text = "Generate"
	inputbox.editable = true
	$VBoxContainer/Panel/MainMenu.disabled = false
	
func send_text():
	$Nobodywhomodule.say("Here's what user replied: " + inputbox.text)
	prev_text = outputbox.text
	$Nobodywhomodule.seed_randomize()
	update_prompt()
	outputbox.text += "[b][color=LIGHTGREEN]User[/color][/b]: " + inputbox.text + "\n"
	prev_text = outputbox.text
	outputbox.text += "[b][color=LIGHTSKYBLUE]AI[/color][/b]: "
	inputbox.text = ""
	disable_buttons()

func _on_input_box_text_submitted(new_text: String) -> void:
	send_text()

func _on_generate_pressed() -> void:
	send_text()

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
	prev_text = ""
	enable_buttons()
	$VBoxContainer/Panel/RestartAI.disabled = false

func _on_menu_option_pressed(id: int) -> void:
	match id:
		4:
			inputbox.text = "I want to make a pony oc based in mlp universe"
			send_text()
		5: 
			inputbox.text = "I want to make a furry oc"
			send_text()
		2: 
			inputbox.text = "Please make it 4 times longer"
			send_text()
		1:
			$Nobodywhomodule.seed_randomize()
		0:
			$Nobodywhomodule.context_reset()
			outputbox.text = ""
			prev_text = ""
			$Nobodywhomodule.seed_randomize()
			update_prompt()

func load_settings():
	outputbox.add_theme_font_size_override("normal_font_size", Globals.settings_font_size)
	outputbox.add_theme_font_size_override("bold_font_size", Globals.settings_font_size)
