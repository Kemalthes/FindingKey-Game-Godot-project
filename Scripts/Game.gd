extends Node

onready var pause_menu = $PauseMenu
onready var load_animation = $LoadBG/Animation
onready var game_music = $GameMusic
onready var open_sound = $Open_sound

func _ready():
	Gen.game = self
	game_music.play()
	Gen.pack = {}
	if Gen.allow_to_play_press_sound: open_sound.play()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Gen.change_level(Gen.saving_stats["level"])
	Gen.ui.hide_inventory_object()
	margin_to_anchor()
	Gen.IN_LEVEL = false
	
func margin_to_anchor():
	pause_menu.margin_bottom = 0
	pause_menu.margin_top = 0
	pause_menu.margin_right = 0
	pause_menu.margin_left = 0

func fade_loading():
	load_animation.play("Fade_back")

func _on_Level_child_entered_tree(node):
	Gen.set_sky(Gen.sky_state)
	Gen.set_shadow(Gen.shadow_state)

func _input(event):
	if event.is_action_released("ui_cancel") and Gen.allow_pause_menu:
		Gen.pause_game(true)
		open_sound.play()
		

