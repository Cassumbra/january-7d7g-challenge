extends CharacterBody2D

@export var foreground: TileMapLayer

const SPEED = 60.0
const JUMP_VELOCITY = -150.0
const GRAVITY = Vector2(0, 400)

var in_air_last_frame = false

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("secondary"):
		var dig_position_1 = foreground.local_to_map(position)
		var dig_position_2 = foreground.local_to_map(position)
		
		var horizontal := Input.get_axis("left", "right")
		var vertical := Input.get_axis("up", "down")
		
		if horizontal:
			dig_position_1.x += horizontal
			if vertical == -1:
				dig_position_2.y += vertical
			elif vertical == 1:
				dig_position_2.y += horizontal
		if vertical:
			dig_position_1.y += vertical
		
		foreground.erase_cell(dig_position_1)
		foreground.erase_cell(dig_position_2)
	
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
		
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		
	if velocity.x != 0 && is_on_floor():
		$AnimatedSprite2D.play("walking")
		if $TimerStep.is_stopped():
			$SpeakerStep.play()
			$TimerStep.start()
	else:
		$AnimatedSprite2D.pause()
		#$AnimatedSprite2D.set_frame_and_progress(0, 0.0)
	
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	

	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_normal().x != 0 && !$AreaClimb.has_overlapping_bodies() && is_on_floor():
			position += Vector2(-collision.get_normal().x * 0.1, -8)
			#print("beep!")
