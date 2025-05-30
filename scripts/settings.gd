extends Control

@onready var model_path = $Panel/ScrollContainer/VBoxContainer/HBoxContainer/LineEdit
@onready var context_length = $Panel/ScrollContainer/VBoxContainer/HBoxContainer2/HSlider
@onready var context_length_suffix = $Panel/ScrollContainer/VBoxContainer/HBoxContainer2/Label2
@onready var current_theme = $Panel/ScrollContainer/VBoxContainer/HBoxContainer3/OptionButton
@onready var font_size = $Panel/ScrollContainer/VBoxContainer/HBoxContainer4/HSlider
@onready var font_size_suffix = $Panel/ScrollContainer/VBoxContainer/HBoxContainer4/Label2
@onready var font_preview = $Panel/ScrollContainer/VBoxContainer/Label
@onready var sound_enabled = $Panel/ScrollContainer/VBoxContainer/HBoxContainer5/CheckButton

@onready var menu_bar = menubar

func _ready():
	load_settings()
	$FileDialog.add_filter("*.gguf", "GGUF Model (*.gguf)")
	
func load_settings():
	model_path.text = Globals.settings_model_path
	context_length.value = Globals.settings_context_length
	context_length_suffix.text = str(int(context_length.value)) + " tokens"
	current_theme.text = "Dark (Default)"
	font_size.value = Globals.settings_font_size
	font_size_suffix.text = str(int(font_size.value)) + " px"
	font_preview.add_theme_font_size_override("font_size", font_size.value)
	sound_enabled.button_pressed = Globals.settings_sound_enabled

func _on_h_slider_value_changed(value: float) -> void:
	font_preview.add_theme_font_size_override("font_size", int(value))
	font_size_suffix.text = str(int(font_size.value)) + " px"

func _on_h_slider_context_value_changed(value: float) -> void:
	context_length.value = int(value)
	context_length_suffix.text = str(int(context_length.value)) + " tokens"

func _on_reset_2_pressed() -> void:
	Globals.settings_model_path = model_path.text
	Globals.settings_context_length = int(context_length.value)
	Globals.settings_font_size = int(font_size.value)
	Globals.settings_sound_enabled = sound_enabled.button_pressed
	Globals.save_settings()
	refresh_in_live()

func refresh_in_live():
	var root = get_tree().get_current_scene()
	if "outputbox" in root:
		root.outputbox.add_theme_font_size_override("font_size", Globals.settings_font_size)
		root.outputbox.add_theme_font_size_override("normal_font_size", Globals.settings_font_size)
		root.outputbox.add_theme_font_size_override("bold_font_size", Globals.settings_font_size)
	if "inputbox" in root:
		root.load_settings()
	
	get_tree().current_scene.get_node("VBoxContainer/MenuBar").show()
	get_node("../").queue_free()


func _on_browse_pressed() -> void:
	$FileDialog.show()

func _on_file_dialog_file_selected(path: String) -> void:
	model_path.text = path


func _on_reset_pressed() -> void:
	model_path.text = Globals.default_settings_model_path
	context_length.value = Globals.default_settings_context_length
	context_length_suffix.text = str(int(context_length.value)) + " tokens"
	current_theme.text = "Dark (Default)"
	font_size.value = Globals.default_settings_font_size
	font_size_suffix.text = str(int(font_size.value)) + " px"
	font_preview.add_theme_font_size_override("font_size", font_size.value)
	sound_enabled.button_pressed = Globals.default_settings_sound_enabled


func _on_reset_3_pressed() -> void:
	get_tree().current_scene.get_node("VBoxContainer/MenuBar").show()
	get_node("../").queue_free()


func _on_check_button_toggled(toggled_on: bool) -> void:
	pass
