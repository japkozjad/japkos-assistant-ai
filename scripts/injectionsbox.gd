extends Panel

var dir = DirAccess.open("rp_injections")

func update_it():
	$OptionButton.clear()
	$OptionButton.add_item("Empty")
	$OptionButton.add_separator()
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
	
		while file_name != "":
			if not dir.current_is_dir():
				$OptionButton.add_item(file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		push_error("Could not open directory")
