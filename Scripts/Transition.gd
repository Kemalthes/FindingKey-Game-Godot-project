extends CanvasLayer

func _ready():
	layer = 1
	Gen.transition = self
	open_scene()
	$Animation.seek(0.0, true)

func open_scene():
	$Animation.play("open_scene")

func close_scene(speed):
	$Animation.play("close_scene")
	$Animation.playback_speed = speed
