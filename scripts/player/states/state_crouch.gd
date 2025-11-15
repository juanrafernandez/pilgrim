extends PlayerState

## Crouch State
## Player is crouched, reducing collision height and movement speed

# Crouch constants
const CROUCH_SPEED_MULTIPLIER: float = 0.5  # 50% of normal speed
const CROUCH_HEIGHT_SCALE: float = 0.6  # Reduce collision height to 60%

var original_collision_height: float = 0.0


func _state_init() -> void:
	# Store original collision shape height
	if player.collision_shape and player.collision_shape.shape is RectangleShape2D:
		original_collision_height = player.collision_shape.shape.size.y


func _state_enter() -> void:
	# Reduce collision shape height
	_set_collision_height(original_collision_height * CROUCH_HEIGHT_SCALE)

	# Reduce horizontal velocity
	player.velocity.x *= CROUCH_SPEED_MULTIPLIER


func _state_exit() -> void:
	# Restore original collision height
	_set_collision_height(original_collision_height)


func _state_physics_update(delta: float) -> void:
	# Apply gravity
	apply_gravity(delta)

	# Apply horizontal movement at reduced speed
	var crouch_speed = player.input_direction.x * CROUCH_SPEED_MULTIPLIER
	if crouch_speed != 0:
		player.velocity.x = move_toward(
			player.velocity.x,
			crouch_speed * player.SPEED,
			player.ACCELERATION * delta
		)
		update_sprite_direction()
	else:
		# Apply friction when not moving
		player.velocity.x = move_toward(player.velocity.x, 0, player.FRICTION * delta)

	# Check transitions
	check_transitions()


func check_transitions() -> void:
	# If throw projectile pressed
	if Input.is_action_just_pressed("special"):
		player.throw_projectile()

	# If crouch released and not obstructed above, stand up
	if not Input.is_action_pressed("crouch"):
		# Check if there's space to stand up
		if _can_stand_up():
			# Return to appropriate state based on movement
			if player.input_direction.x != 0:
				state_machine.change_state("Walk")
			else:
				state_machine.change_state("Idle")
		return

	# If attack pressed, go to Attack (can attack while crouched)
	if Input.is_action_just_pressed("attack") and not player.is_attacking:
		state_machine.change_state("Attack")
		return

	# If in air, go to Fall
	if not player.is_on_floor() and player.velocity.y > 0:
		state_machine.change_state("Fall")
		return

	# If dead, go to Death
	if player.is_dead:
		state_machine.change_state("Death")
		return


func _set_collision_height(new_height: float) -> void:
	"""Adjust collision shape height and position"""
	if player.collision_shape and player.collision_shape.shape is RectangleShape2D:
		var shape = player.collision_shape.shape as RectangleShape2D
		var old_height = shape.size.y
		var height_diff = old_height - new_height

		# Update shape size
		shape.size.y = new_height

		# Adjust position to keep feet at same level
		# Move collision shape down when crouching, up when standing
		player.collision_shape.position.y += height_diff / 2.0


func _can_stand_up() -> bool:
	"""Check if there's space above to stand up"""
	# Simple check: use a raycast or area check
	# For now, always allow standing (can be improved with actual collision check)
	# TODO: Add proper headroom check with raycast
	return true
