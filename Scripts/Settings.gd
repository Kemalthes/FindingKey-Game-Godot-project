extends Control

export var max_language_id = 1

onready var v_sync = $Margin/VBox/Grid/Fps/Vsync
onready var target_fps = $Margin/VBox/Grid/Fps/TargetFps/LineEdit
onready var shadow = $Margin/VBox/Grid/Graphics/Shadow
onready var sky = $Margin/VBox/Grid/Graphics/Sky
onready var fullscreen = $Margin/VBox/Grid/Graphics/Fullscreen
onready var language = $Margin/VBox/Grid/Language/Language
onready var s_mute = $Margin/VBox/Grid/Sounds/Sound/S_Mute
onready var m_mute = $Margin/VBox/Grid/Sounds/Music/M_Mute
onready var s_scroll = $Margin/VBox/Grid/Sounds/Sound/Scroll/S_HScroll
onready var m_scroll = $Margin/VBox/Grid/Sounds/Music/Scroll/M_HScroll
onready var open_sound = $Open_sound
onready var menu_music = $MenuMusic

var transition_copy = preload("res://Scenes/Transition.tscn")

func _ready():
	menu_music.play()
	open_sound.play()
	v_sync.pressed = Gen.saving_stats["v_sync"]
	fullscreen.pressed = Gen.saving_stats["fullscreen"]
	sky.pressed = Gen.saving_stats["sky"]
	shadow.pressed = Gen.saving_stats["shadow"]
	s_mute.pressed = Gen.saving_stats["s_sound"]
	m_mute.pressed = Gen.saving_stats["m_sound"]
	s_scroll.value = Gen.saving_stats["s_value"]
	m_scroll.value = Gen.saving_stats["m_value"]
	target_fps.text = str(Gen.saving_stats["target_fps"])
	change_language_icon(Gen.saving_stats["language_id"])
	$Back.grab_focus()

func change_language_icon(value):
	match value:
		0:
			language.text = "Русский"
			language.icon = preload("res://Main/UIicons/RUS.png")
		1:
			language.text = "English"
			language.icon = preload("res://Main/UIicons/ENG.png")

func save_values():
	var target_value = int(target_fps.text) if (int(target_fps.text) >= 15 and int(target_fps.text) <= 960) else 60
	Engine.set_target_fps(target_value)
	Gen.saving_stats["target_fps"] = target_value
	if Gen.IN_LEVEL:
		Gen.game.get_node("Settings").queue_free()
		var new_transition = transition_copy.instance()
		Gen.game.add_child(new_transition)
		new_transition.get_node("FadeColor").color = Color(0,0,0,0)
	else:
		Gen.change_scene(Gen.To_menu)

func _on_Vsync_pressed():
	open_sound.play()
	if v_sync.pressed:
		OS.vsync_enabled = true
		Gen.saving_stats["v_sync"] = true
	else: 
		OS.vsync_enabled = false
		Gen.saving_stats["v_sync"] = false

func _on_Shadow_pressed():
	open_sound.play()
	if shadow.pressed:
		Gen.shadow_state = true
		Gen.saving_stats["shadow"] = true
	else: 
		Gen.shadow_state = false
		Gen.saving_stats["shadow"] = false

func _on_Sky_pressed():
	open_sound.play()
	if sky.pressed:
		Gen.sky_state = true
		Gen.saving_stats["sky"] = true
	else:
		Gen.sky_state = false
		Gen.saving_stats["sky"] = false 

func _on_Fullscreen_pressed():
	open_sound.play()
	if fullscreen.pressed:
		OS.window_fullscreen = true
		Gen.saving_stats["fullscreen"] = true
	else:
		OS.window_fullscreen = false
		Gen.saving_stats["fullscreen"] = false
	
func _on_Language_pressed():
	open_sound.play()
	var language_id = Gen.saving_stats["language_id"]
	if language_id != max_language_id:
		change_language_icon(language_id + 1) 
		Gen.saving_stats["language_id"] = language_id + 1
	else:
		change_language_icon(0)
		Gen.saving_stats["language_id"] = 0
	match language_id:
		0: Gen.set_language("en")
		1: Gen.set_language("ru")

func _on_S_Mute_pressed():
	open_sound.play()
	if s_mute.pressed:
		Gen.mute(Gen.sound_bus, false)
		Gen.saving_stats["s_sound"] = true
	else:
		Gen.mute(Gen.sound_bus, true)
		Gen.saving_stats["s_sound"] = false

func _on_M_Mute_pressed():
	open_sound.play()
	if m_mute.pressed:
		Gen.mute(Gen.music_bus, false)
		Gen.saving_stats["m_sound"] = true
	else:
		Gen.mute(Gen.music_bus, true)
		Gen.saving_stats["m_sound"] = false

func _on_S_HScroll_value_changed(value):
	Gen.change_volume(Gen.sound_bus, value, "s")
	Gen.saving_stats["s_value"] = value

func _on_M_HScroll_value_changed(value):
	Gen.change_volume(Gen.music_bus, value, "m")
	Gen.saving_stats["m_value"] = value

func _input(event):
	if event.is_action_released("ui_cancel"):  #&& !Gen.IN_LEVEL
		save_values()
		if Gen.IN_LEVEL:
			Gen.pause_menu.get_node("Margin").get_node("VBox").get_node("Continue").get_node("Continue_Button").grab_focus()
func _on_Back_pressed():
	save_values()
	if Gen.IN_LEVEL:
		Gen.pause_menu.get_node("Margin").get_node("VBox").get_node("Continue").get_node("Continue_Button").grab_focus()
