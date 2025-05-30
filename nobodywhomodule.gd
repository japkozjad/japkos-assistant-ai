extends Node

var systemprompt = ""
var sampler_seed = 0

var sampler = NobodyWhoSampler.new()

func _ready():
	$NobodyWhoChat.sampler = sampler
	sampler.set("temperature", 1.0)
	load_settings()
	seed_randomize()
	set_systemprompt()

func _on_nobody_who_chat_response_finished(response: String) -> void:
	if get_node("../").has_node("AI_REPLYMODULE"):
		get_node("../").outputbox.text = get_node("../").prev_text + "[b][color=LIGHTSKYBLUE]AI[/color][/b]: " + response  + "\n"
	else:
		get_node("../").outputbox.text = response
	get_node("../").enable_buttons()
	if Globals.settings_sound_enabled == true:
		$GenCompleteSound.play()


func _on_nobody_who_chat_response_updated(new_token: String) -> void:
	get_node("../").outputbox.text += new_token.replace("\n", new_token)
	if Globals.settings_sound_enabled == true:
		$NewTokenSound.play()

func say(message: String) -> void:
	$NobodyWhoChat.say(message)
	
func seed_randomize():
	sampler.set("seed", randi_range(0,9999999))
	$NobodyWhoChat.sampler = sampler

func context_reset():
	$NobodyWhoChat.reset_context()
	
func set_systemprompt():
	$NobodyWhoChat.system_prompt = systemprompt

func load_settings():
	$NobodyWhoChat.context_length = Globals.settings_context_length
	print($NobodyWhoChat.context_length)
	$NobodyWhoModel.model_path = Globals.settings_model_path
	print($NobodyWhoModel.model_path)
