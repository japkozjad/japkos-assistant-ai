extends Control

@onready var json_module = JsonModule.new()
@onready var outputbox = $VBoxContainer/Panel/HSplitContainer/OutputBox
@onready var inputbox = $VBoxContainer/Panel/InputBox
@onready var injectionsbox = $VBoxContainer/Panel/HSplitContainer/Injectionsbox/InjectionsBox

@onready var nobodywhomodule = preload("res://nobodywhomodule.tscn")
var prompt_path = "prompts/roleplayidea.json"

var content_rating = ""

var rating_explicit = " Focus on sexual and arousal topics. Detalic sexual acts descriptions and direct names (like blowjob, anal, cum and etc.) are strictly allowed."
var rating_grimdark = " Focus on violent and gore topics. Detalic grimdark descriptions, violence and selfharm topics are strictly allowed."
var rating_combo = " Focus on violent, gore, sexual and arousal topics. Detalic sexual acts descriptions and direct names (like blowjob, anal, cum and etc.), detalic grimdark descriptions, violence and selfharm topic are strictly allowed."

var nsfw_active = false
var grimdark_active = false

var custominjections = ""

func _ready():
	DisplayServer.window_set_title("Japko's Assistant AI - Roleplay Generator", 0)
	update_prompt()
	load_settings()

func disable_buttons():
	$VBoxContainer/Panel/Generate.disabled = true
	$VBoxContainer/Panel/Generate.text = "Generating..."
	inputbox.editable = false
	$VBoxContainer/Panel/NSFWCheck.disabled = true
	$VBoxContainer/Panel/GrimdarkCheck.disabled = true
	$VBoxContainer/Panel/Injections.disabled = true
	$VBoxContainer/Panel/MainMenu.disabled = true
	
func enable_buttons():
	$VBoxContainer/Panel/Generate.disabled = false
	$VBoxContainer/Panel/Generate.text = "Generate"
	inputbox.editable = true
	$VBoxContainer/Panel/NSFWCheck.disabled = false
	$VBoxContainer/Panel/GrimdarkCheck.disabled = false
	$VBoxContainer/Panel/Injections.disabled = false
	$VBoxContainer/Panel/MainMenu.disabled = false

func update_rating():
	if nsfw_active == true && grimdark_active == false:
		content_rating = rating_explicit
		print("Content rating set to Explicit.")
	elif nsfw_active == false && grimdark_active == true:
		content_rating = rating_grimdark
		print("Content rating set to Grimdark.")
	elif nsfw_active == true && grimdark_active == true:
		content_rating = rating_combo
		print("Content rating set to Explicit & Grimdark.")
	else:
		content_rating = ""
		print("Content rating set to Safe.")
		
func update_prompt():
	json_module.load_sysprompt(prompt_path)
	$Nobodywhomodule.systemprompt = json_module.systemprompt + content_rating
	$Nobodywhomodule.set_systemprompt()
	print("System prompt set to: " + $Nobodywhomodule/NobodyWhoChat.system_prompt)

func _on_nsfw_check_toggled(toggled_on: bool) -> void:
	nsfw_active = toggled_on
	update_rating()
	update_prompt()

func _on_grimdark_check_toggled(toggled_on: bool) -> void:
	grimdark_active = toggled_on
	update_rating()
	update_prompt()

func generate():
	update_rating()
	update_prompt()
	$Nobodywhomodule.context_reset()
	$Nobodywhomodule.seed_randomize()
	if custominjections != "":
		$Nobodywhomodule.say("Here's the request of ideas for roleplay: " +inputbox.text + " Output only the ideas without header. If there's a request of more than one, output it in numeric order. Here's additional info: " + custominjections)
		print("Message sent: " + "Here's the request of ideas for roleplay: " +inputbox.text + " Output only the ideas without header. If there's a request of more than one, output it in numeric order. Here's additional info: " + custominjections)
	else:
		$Nobodywhomodule.say("Here's the request of ideas for roleplay: " +inputbox.text + " Output only the ideas without header. If there's a request of more than one, output it in numeric order.")
		print("Message sent: " + "Here's the request of ideas for roleplay: " +inputbox.text + " Output only the ideas without header. If there's a request of more than one, output it in numeric order.")
	
		
	inputbox.text = ""
	outputbox.text = ""
	disable_buttons()
	
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

func _on_generate() -> void:
	generate()

func _on_main_menu_pressed() -> void:
	$Nobodywhomodule.queue_free()
	get_tree().change_scene_to_file("res://scenes/main_ui.tscn")

func _on_input_box_text_submitted(new_text: String) -> void:
	generate()

func _on_injections_pressed() -> void:
	if $VBoxContainer/Panel/HSplitContainer/Injectionsbox.visible == false:
		$VBoxContainer/Panel/HSplitContainer/Injectionsbox.update_it()
		$VBoxContainer/Panel/HSplitContainer/Injectionsbox.show()
	else:
		$VBoxContainer/Panel/HSplitContainer/Injectionsbox.hide()

func _on_option_button_item_selected(index: int) -> void:
	var selected_text = $VBoxContainer/Panel/HSplitContainer/Injectionsbox/OptionButton.get_item_text(index)
	if selected_text != "Empty":
		var file = FileAccess.open("rp_injections/"+selected_text, FileAccess.READ)
		injectionsbox.text = file.get_as_text()
		file.close()
	else:
		injectionsbox.text = ""

func _on_injections_box_text_changed() -> void:
	custominjections = injectionsbox.text
	
func _on_injections_box_text_set() -> void:
	custominjections = injectionsbox.text
	print("Injections set.")

func load_settings():
	outputbox.add_theme_font_size_override("normal_font_size", Globals.settings_font_size)
	outputbox.add_theme_font_size_override("bold_font_size", Globals.settings_font_size)
