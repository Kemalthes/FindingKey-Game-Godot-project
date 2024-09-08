extends KinematicBody

var jump = 14
var speed = 7
var gravity = 0.8
var rotate = 0.2

var velocity = Vector3()
var state = "Idle"
var speed_anim = { "Move": 2.5, "Idle": 1.5, "None": 1 }

func _ready():
	Gen.player = self
	$Animation.play(state)
	
func _physics_process(delta):
	var direction = Vector3()
	if Input.is_action_pressed("jump") && is_on_floor():
		velocity.y = jump
		if Gen.saving_stats["level"] == 10 && Gen.pack.has("key"):
			Gen.count_jump += 1
	if Input.is_action_pressed("ui_down"):
		direction.z = 1
	elif Input.is_action_pressed("ui_up"):
		direction.z = -1
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
	elif Input.is_action_pressed("ui_left"):
		direction.x = -1

	if Input.is_action_pressed("headright"):
		self.rotation_degrees.y += -3
	elif Input.is_action_pressed("headleft"):
		self.rotation_degrees.y += 3
	if Input.is_action_pressed("headup"):
		if $Head.rotation_degrees.x < 75:
			$Head.rotation_degrees.x += 3
	elif Input.is_action_pressed("headdown"):
		if $Head.rotation_degrees.x > -75:
			$Head.rotation_degrees.x += -3

	if direction.x || direction.z:
		direction = direction.rotated(Vector3.UP, rotation.y).normalized() * speed
		if is_on_floor() && (Input.is_action_pressed("ui_down") || Input.is_action_pressed("ui_up")):
			state = "Move"
		else:
			state = "None"
	else:
		state = "Idle"
	
	velocity.y -= gravity
	velocity.x = direction.x
	velocity.z = direction.z
	velocity = velocity.linear_interpolate(direction * speed, 1 * delta)
	velocity = move_and_slide(velocity, Vector3.UP, true, 4, PI/3)
	if transform.origin.y < -25:
		Gen.start_pos()
	
	if $Animation.current_animation != state:
		$Animation.play(state)
		$Animation.playback_speed = speed_anim[state]

func _input(event):
	if event is InputEventMouseMotion && Gen.IN_LEVEL:
		self.rotation_degrees.y += -event.relative.x * rotate
		$Head.rotation_degrees.x = clamp($Head.rotation_degrees.x + -event.relative.y * rotate, -75, 75)	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && Gen.act_obj && event.is_pressed():
			Gen.act_obj.call("action")
	if event.is_action_pressed("ui_use") && Gen.act_obj:
		Gen.act_obj.call("action")
		
