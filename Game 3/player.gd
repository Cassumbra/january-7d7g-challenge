extends CharacterBody2D


const SPEED = 60.0
const ACCEL = 120.0
const DEACCEL = 180.0
const JUMP_VELOCITY = -150.0
const GRAVITY = Vector2(0, 400)


var in_air_last_frame = false

var can_start_float = false
var is_floating = false
var float_direction = Vector2.ZERO
var float_velocity = 0.0

func _physics_process(delta: float) -> void:
	if position.y > 140:
		$SpeakerDie.play()
		position = Vector2(2.0, -3.0)
	
	if is_on_floor() && in_air_last_frame:
		$SpeakerLand.play()
	
	# Add the gravity.
	if not is_on_floor():
		in_air_last_frame = true
		velocity += GRAVITY * delta
	else:
		in_air_last_frame = false
		can_start_float = true
		
		

	# Handle jump.
	if Input.is_action_just_pressed("primary") and is_on_floor():
		velocity.y = JUMP_VELOCITY


		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var horizontal := Input.get_axis("left", "right")
	var vertical := Input.get_axis("up", "down")
	if horizontal:
		if horizontal == 1 && velocity.x < SPEED:
			velocity.x = move_toward(velocity.x, SPEED, ACCEL * delta)
		elif horizontal == -1 && velocity.x > -SPEED:
			velocity.x = move_toward(velocity.x, -SPEED, ACCEL * delta)
	#TODO: I think pressing nothing is a faster deaccel than holding back? this is weird!
	else:
		velocity.x = move_toward(velocity.x, 0, DEACCEL * delta)
		
	# Handle float.
	if Input.is_action_just_pressed("secondary") && can_start_float:
		is_floating = true
		can_start_float = false
		float_direction = Vector2(horizontal, vertical)
		float_velocity = velocity.length()
		$TimerFloat.start()
		
	if Input.is_action_just_released("secondary") || $TimerFloat.is_stopped():
		is_floating = false
	
	if is_floating:
		velocity = float_velocity * float_direction
		
	if velocity.x != 0 && is_on_floor():
		$AnimatedSprite2D.play("walking")
		if $TimerStep.is_stopped():
			$SpeakerStep.play()
			$TimerStep.start()
	else:
		$AnimatedSprite2D.pause()
		$AnimatedSprite2D.set_frame_and_progress(0, 0.0)
	
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	

	move_and_slide()
