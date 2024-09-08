extends Area

func _on_FinishPos_body_entered(body):
	if body.name == "Player":
		if Gen.saving_stats["level"] != 10:
			Gen.saving_stats["level"] += 1
			Gen.reload_scene()
		else:
			Gen.change_scene(Gen.FinishScene)
			Gen.saving_stats["level"] += 1
