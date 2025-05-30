extends Node

class_name JsonModule

var systemprompt: String

func load_json_file(path: String) -> Dictionary:
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open JSON file: %s" % path)
		return {}
	
	var json_text = file.get_as_text()
	file.close()
	
	var result = JSON.parse_string(json_text)
	if result == null:
		push_error("Failed to parse JSON content in: %s" % path)
		return {}
	
	return result

func load_sysprompt(path: String):
	var data = load_json_file(path)
	if "content" in data:
		systemprompt = data["content"]
