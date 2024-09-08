extends Area

export var act_name = ""
export var act_id = ""
export var delete = false
export var call_func = ""

func action():
	if act_id:
		Gen.pack[act_id]  = {"name": act_name}
	if call_func:
		get_parent().call(call_func)
	if delete:
		get_parent().queue_free()
