extends RayCast

onready var prev_obj = null

func _physics_process(delta):
	var cur_obj = get_collider()
	if !cur_obj && prev_obj:
		Gen.act_obj = null
	elif cur_obj != Gen.act_obj && "act_name" in cur_obj:
		Gen.act_obj = cur_obj
	if cur_obj != prev_obj:
		prev_obj = cur_obj
