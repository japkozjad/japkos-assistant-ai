extends Control

func _ready():
	$TabContainer/About.text = $TabContainer/About.text.replace("%versionplaceholder%", ProjectSettings.get_setting("application/config/version"))
	$TabContainer/Licenses/ItemList.select(0)
	load_license_file("program.txt")
	$TabContainer/Licenses/RichTextLabel.text = license

func _on_about_meta_clicked(meta: Variant) -> void:
	OS.shell_open(meta)


var license: String

func load_license_file(filename: String) -> void:
	var file = FileAccess.open("licenses/" + filename, FileAccess.READ)
	license = file.get_as_text()
	file.close()

func _on_item_list_item_selected(index: int) -> void:
	if index == 0:
		load_license_file("program.txt")
	elif index == 1:
		load_license_file("nobodywho.txt")
	elif index == 2:
		load_license_file("fluentui-system-color-icons.txt")
	elif index == 3:
		load_license_file("fluentui-emojis.txt")
	elif index == 4:
		load_license_file("famicons.txt")
	elif index == 5:
		load_license_file("tabler-icons.txt")
	$TabContainer/Licenses/RichTextLabel.text = license
