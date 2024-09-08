extends Spatial

const effect = preload("res://Objects/Effects.tscn")

func _ready():
	$Animation.play("key_anim")
	
func _physics_process(delta):
	$KeyMesh.rotation.y += delta
	
func set_effect():
	Gen.game.get_node("Claim_sound").play()
	var effect_instance = effect.instance()
	get_parent().add_child(effect_instance)
	effect_instance.transform.origin = transform.origin
	effect_instance.get_child(0).set_emitting(true)
	if Gen.pack.has("key") || Gen.pack.has("key_false"):
		Gen.ui.show_inventory_object()
		Gen.ui.show_inventory_object()
