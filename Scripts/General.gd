extends Node

var ui
var game
var player
var camera
var transition
var pause_menu

var pack = {}
var startposes = {}
var act_obj = null

var IN_LEVEL = false
var first_open_menu = false
var allow_pause_menu = true
var allow_to_play_press_sound = true
var sky_state = true
var shadow_state = true
var count_jump = 0
var playtime = 0

var To_menu = preload("res://Scenes/MainMenu.tscn")
var Game_scene = preload("res://Scenes/Game.tscn")
var Settings_scene = preload("res://Scenes/Settings.tscn")
var AboutScene = preload("res://Scenes/AboutScene.tscn")
var FinishScene = preload("res://Levels/final.tscn")
const sky_env = preload("res://Objects/Sky.tscn")

var sound_bus = AudioServer.get_bus_index("Sound")
var music_bus = AudioServer.get_bus_index("Music")

var save_path = "user://savings.dat"

var saving_stats = {
	"level": 1,
	"v_sync": true,
	"sky": true,
	"shadow": true,
	"fullscreen": true,
	"language_id": 0,
	"target_fps": 60,
	"s_sound": true,
	"m_sound": true,
	"s_value": 0,
	"m_value": 0,
	"time": 0
}

func _physics_process(delta):
	if IN_LEVEL:
		playtime += delta
		
func setup_settings():
	OS.vsync_enabled = saving_stats["v_sync"]
	shadow_state = saving_stats["shadow"]
	sky_state = saving_stats["sky"]
	OS.window_fullscreen = saving_stats["fullscreen"]
	Engine.set_target_fps(saving_stats["target_fps"])
	AudioServer.set_bus_mute(sound_bus, not saving_stats["s_sound"])
	AudioServer.set_bus_mute(music_bus, not saving_stats["m_sound"])
	change_volume(sound_bus, saving_stats["s_value"], "s")
	change_volume(music_bus, saving_stats["m_value"], "m")
	playtime = saving_stats["time"]
	match saving_stats["language_id"]:
		0: set_language("ru")
		1: set_language("en")

func save_data():
	saving_stats["time"] = playtime
	var save_file = File.new()
	save_file.open_encrypted_with_pass(save_path, File.WRITE, "rFk49r!Gk4&o5Иc$")
	save_file.store_var(saving_stats)
	save_file.close()

func load_data():
	var save_file = File.new()
	if not save_file.file_exists(save_path): return
	save_file.open_encrypted_with_pass(save_path, File.READ, "rFk49r!Gk4&o5Иc$")
	var new_data = save_file.get_var()
	save_file.close()
	if not new_data: return
	saving_stats = new_data
	setup_settings()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_data()
	if what == NOTIFICATION_ENTER_TREE:
		load_data()
		
func mute(bus, value: bool):
	AudioServer.set_bus_mute(bus, value)

func change_volume(bus, value, type: String):
	AudioServer.set_bus_volume_db(bus, value)
	if saving_stats[type+"_value"] < -25:
		mute(bus, true)
	elif saving_stats[type+"_sound"]:
		mute(bus, false)

func pause_game(mode):
	if mode:
		pause_menu.get_node("Animation").play("StartPause")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause_menu.get_node("Margin").get_node("VBox").get_node("Continue").get_node("Continue_Button").focus_mode = 2
		pause_menu.get_node("Margin").get_node("VBox").get_node("Continue").get_node("Continue_Button").grab_focus()
	else:
		pause_menu.get_node("Animation").play("ClosePause")
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		pause_menu.get_node("Margin").get_node("VBox").get_node("Continue").get_node("Continue_Button").focus_mode = 0
	ui.get_node("Pause").get_node("Button").pressed = mode
	get_tree().paused = mode

func set_language(language):
	TranslationServer.set_locale(language)

func set_sky(state):
	if state:
		game.add_child(sky_env.instance())
	else:
		if game.get_node("Sky"):
			game.get_node("Sky").queue_free()

func set_shadow(state):
	if game.get_node("Level").has_node("L" + str(saving_stats["level"])):
		game.get_node("Level").get_node("L" + str(saving_stats["level"])).get_node("Light").shadow_enabled = state
		
func fade(type, speed = 1):
	match type:
		"loading":
			game.fade_loading()
		"close_scene":
			transition.close_scene(speed)

func change_scene(scene):
	if scene is Object:
		return get_tree().change_scene_to(scene)

func reload_scene():
	fade("close_scene", 0.5)
	yield(transition.get_node("Animation"), "animation_finished")
	allow_to_play_press_sound = false
	return get_tree().reload_current_scene()
	
func change_level(cur_level):
	allow_pause_menu = false
	IN_LEVEL = false
	var loader = ResourceLoader.load_interactive("res://Levels/L" + str(cur_level) + ".tscn")
	var load_bar = game.get_node("LoadBG").get_node("Loading")
	if !loader: 
		save_data()
		change_scene(To_menu)
	while true:
		var error = loader.poll()
		if error == OK:
			load_bar.value = float(loader.get_stage()) / loader.get_stage_count() * 100
			yield(get_tree().create_timer(0.017), "timeout")
		elif error == ERR_FILE_EOF:
			load_bar.value = 100
			yield(get_tree().create_timer(0.017), "timeout")
			fade("loading")
			var lvl = loader.get_resource().instance()
			game.get_node("Level").add_child(lvl)
			IN_LEVEL = true
			break
	start_pos()

func start_pos():
	if IN_LEVEL:
		var start_pos = startposes["lvl" + str(saving_stats["level"])]
		player.global_transform = start_pos.global_transform
		camera.global_transform = player.get_node("Head").global_transform
