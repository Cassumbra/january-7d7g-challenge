extends CharacterBody2D

@export var collectables: TileMapLayer

const SPEED = 60.0

var score = 0
var multiplier = 1

func _ready() -> void:
	$AnimatedSprite2D.play()

func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var horizontal := Input.get_axis("left", "right")
	if !$TimerInebriation.is_stopped():
		horizontal *= -1
	if horizontal:
		velocity.x = horizontal * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	var vertical := Input.get_axis("up", "down")
	if !$TimerInebriation.is_stopped():
		vertical *= -1
	if vertical:
		velocity.y = vertical * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		

	
	if horizontal != 0:
		$Reticle.position = Vector2(horizontal, 0) * 12
	elif vertical != 0:
		$Reticle.position = Vector2(0, vertical) * 12
	
	if velocity != Vector2.ZERO:
		$AnimatedSprite2D.play("walking")
		if $TimerStep.is_stopped():
			$SpeakerStep.play()
			$TimerStep.start()
	else:
		$AnimatedSprite2D.play("default")
		
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false

	move_and_slide()
	
	if $Area.overlaps_body(collectables):
		print("wghat")
		var collided_tile = collectables.local_to_map(position)
		var data = collectables.get_cell_tile_data(collided_tile)
		
		if data:
			collectables.erase_cell(collided_tile)
			print("smiles")
			match data.get_custom_data("Collectable"):
				"regular":
					score += 1 * multiplier
				"fermented":
					multiplier *= 2
					$TimerInebriation.start()
				"bad":
					score += -1 * multiplier
				"blue":
					score += 10 * multiplier
					
	if Input.is_action_just_pressed("primary"):
		pass
		#for $Reticle.
		


func _on_timer_inebriation_timeout() -> void:
	multiplier = 1
