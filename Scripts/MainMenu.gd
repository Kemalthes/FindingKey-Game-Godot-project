extends Node

onready var menu_music = $MenuMusic
onready var open_sound = $Open_sound

func _ready():
	Gen.saving_stats["time"] = Gen.playtime
	Gen.count_jump = 0
	Gen.IN_LEVEL = false
	Gen.allow_to_play_press_sound = true
	menu_music.play()
	if Gen.first_open_menu:
		open_sound.play()
	else:
		Gen.first_open_menu = true
	$"2DNode/LeftSide/VBox/Buttons/Start".grab_focus()

func _on_Start_pressed():
	Gen.saving_stats["level"] = 1
	Gen.saving_stats["time"] = 0
	Gen.playtime = 0
	Gen.change_scene(Gen.Game_scene)
	
func _on_Continue_pressed():
	if Gen.saving_stats["level"] > 1:
		if Gen.saving_stats["level"] <= 10:
			Gen.change_scene(Gen.Game_scene)
		else:
			Gen.change_scene(Gen.FinishScene)
	else:
		open_sound.play()

func _on_Settings_pressed():
	Gen.change_scene(Gen.Settings_scene)
	
func _on_About_pressed():
	Gen.change_scene(Gen.AboutScene)

func _on_Quit_pressed():
	Gen.save_data()
	get_tree().quit()

func _input(event):
	if event.is_action_released("ui_cancel"):
		Gen.save_data()
		get_tree().quit()

