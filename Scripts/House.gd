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
	if !name_key || (name_key && Gen.pack.has(name_key)):
		if Gen.saving_stats["level"] != 10 || (Gen.saving_stats["level"] == 10 && Gen.count_jump > 50):
			success_sound.play()
			door.get_node("Animation").play("Open")
			door.get_node("Action").queue_free()
			Gen.ui.hide_inventory_object()
	elif allow_sound:
		failure_sound.play()
		Gen.ui.alert("id_alert")
