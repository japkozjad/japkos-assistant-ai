extends MenuBar

class_name menubar

@onready var about_summoner = AboutSummoner.new()
@onready var about_screen = preload("res://scenes/about.tscn")
@onready var settings_screen = preload("res://scenes/settings.tscn")

var window

func _on_help_id_pressed(id: int) -> void:
	if id == 0:
		window = null
		window = Window.new()
		print("Initiating About Window")
		get_node("../").add_child(window)
		window.hide()
		window.name = "About"
		window.title = "About Japko's Assistant AI..."
		window.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
		window.size = Vector2(600,350)
		window.force_native = true
		window.popup_window = true
		window.unresizable = true
		window.gui_embed_subwindows = true
		window.close_requested.connect(Callable(self, "popup_close_request"))
		window.add_child(about_screen.instantiate())
		self.hide()
		window.show()
		
			
	if id == 2:
		OS.shell_open("https://japkozjad.github.io")
	if id == 3:
		OS.shell_open("https://discord.gg/UE6dz92Mgr")

func hide_edit():
	$".".remove_child($Edit)
	
func show_edit():
	$".".add_child($Edit)

func _on_edit_id_pressed(id: int) -> void:
	if id == 0:
		DisplayServer.clipboard_set(get_parent().get_node("../").outputbox.text)
	if id == 1:
		get_parent().get_node("../").inputbox.text = DisplayServer.clipboard_get()

func popup_close_request():
	window.queue_free()
	self.show()


func _on_tools_id_pressed(id: int) -> void:
	if id == 0:
		window = null
		window = Window.new()
		print("Initiating Settings Window")
		get_node("../").add_child(window)
		window.hide()
		window.name = "Settings"
		window.title = "Application Settings"
		window.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
		window.size = Vector2(700,500)
		window.force_native = true
		window.popup_window = false
		window.gui_embed_subwindows = true
		window.close_requested.connect(Callable(self, "popup_close_request"))
		window.add_child(settings_screen.instantiate())
		window.show()
		self.hide()
	
	if id == 2:
		OS.shell_open("notepad.exe")
