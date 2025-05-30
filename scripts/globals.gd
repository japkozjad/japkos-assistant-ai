extends Node

var default_settings_model_path = "model.gguf"
var default_settings_context_length = 4096
var default_settings_font_size = 11
var default_settings_sound_enabled = false

var settings_model_path = default_settings_model_path
var settings_context_length = default_settings_context_length
var settings_theme #not implemented
var settings_font_size = default_settings_font_size
var settings_sound_enabled = default_settings_sound_enabled

func load_settings():
	var config = ConfigFile.new()
	var err = config.load("config.conf")
	if err != OK:
		print("Config file doesn't exist." + str(err))
		config.set_value("MODEL", "model_path", default_settings_model_path)
		config.set_value("MODEL", "context_length", default_settings_context_length)
		config.set_value("APPEARANCE", "font_size", default_settings_font_size)
		config.set_value("SOUNDS", "enabled", default_settings_sound_enabled)
		config.save("config.conf")
		return
	
	settings_model_path = config.get_value("MODEL", "model_path")
	settings_context_length = config.get_value("MODEL", "context_length")
	settings_font_size = config.get_value("APPEARANCE", "font_size")
	settings_sound_enabled = config.get_value("SOUNDS", "enabled")
	
func save_settings():
	var config = ConfigFile.new()
	config.set_value("MODEL", "model_path", settings_model_path)
	config.set_value("MODEL", "context_length", settings_context_length)
	config.set_value("APPEARANCE", "font_size", settings_font_size)
	config.set_value("SOUNDS", "enabled", settings_sound_enabled)
	config.save("config.conf")
