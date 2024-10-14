extends Spatial

export var name_key = "key"

onready var success_sound = $Success
onready var failure_sound = $Failure
onready var door = $Door

var allow_sound = true

func _process(delta):
	if failure_sound.get_playback_position() >= 0.56 || failure_sound.get_playback_position() == 0:
		allow_sound = true
	else:
		allow_sound = false


func open():
#ATTENTION: BAD CODE, maybe in future I will rework it
	var is_key = !name_key || (name_key && Gen.pack.has(name_key))
	if !(Gen.saving_stats["level"] in Gen.MOD_LEVELS):
		if is_key:
			open_door()
		else:
			failure(is_key)
	elif Gen.saving_stats["level"] == 10:
		if is_key && Gen.count_jump > 50:
			open_door()
		else:
			failure(is_key, "id_else_alert")
	
func open_door():
	success_sound.play()
	door.get_node("Animation").play("Open")
	door.get_node("Action").queue_free()
	Gen.ui.hide_inventory_object()
	
func failure(is_key:bool, else_id=null):
	if allow_sound:
		failure_sound.play()
		if !is_key:
			Gen.ui.alert("id_alert")
		elif else_id:
			Gen.ui.alert(else_id)
