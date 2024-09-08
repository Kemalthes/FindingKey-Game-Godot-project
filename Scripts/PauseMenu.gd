extends Control

func _ready():
	Gen.pause_menu = self


func _on_Continue_Button_pressed():
	Gen.pause_game(false)
	Gen.set_sky(Gen.sky_state)
	Gen.set_shadow(Gen.shadow_state)

func _on_Back_Button_pressed():
	Gen.pause_game(false)
	Gen.change_scene(Gen.To_menu)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_Settings_Button_pressed():
	Gen.game.add_child(Gen.Settings_scene.instance())
	Gen.game.get_node("Settings").pause_mode = PAUSE_MODE_PROCESS
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
func _on_Game_child_exiting_tree(node):
	if Gen.game.has_node("Settings"):
		if node == Gen.game.get_node("Settings"):
			$Open_sound.play()

