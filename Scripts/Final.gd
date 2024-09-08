extends Control

onready var label = $All_time/Time
var int_time = 0

func _ready():
	int_time = int(Gen.playtime)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	label.text = str(int_time / 3600) + " : " + str(int_time % 3600 / 60) + " : " + str(int_time % 3600 % 60)

func _on_Button_pressed():
	Gen.change_scene(Gen.To_menu)
