extends Control

onready var level_title = $LevelNumber/Num
onready var fps = $FPS
onready var center = $Center
onready var act_name = $Interactive/Act_name
onready var alert_text = $Interactive/Alert/AlertText
onready var alert_animation = $Interactive/Alert/Animation
onready var ui_key = $Inventory/Key

func _ready():
	Gen.ui = self
	level_title.text = " " + str(Gen.saving_stats["level"])
	
func _physics_process(delta):
	fps.text = "FPS: " + str(Engine.get_frames_per_second())
	if is_instance_valid(Gen.act_obj):
		set_act_name(Gen.act_obj.act_name)
		center.rect_scale = Vector2(1.5, 1.5)
	else:
		set_act_name("")
		center.rect_scale = Vector2(1, 1)
		
func set_act_name(name):
	act_name.text = name
	
func alert(text):
	alert_text.text = text
	alert_animation.play("Show")
	
func show_inventory_object():
	ui_key.show()
	ui_key.get_node("Animation").play("Key_fade")

func hide_inventory_object():
	ui_key.hide()
