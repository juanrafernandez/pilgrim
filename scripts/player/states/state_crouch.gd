extends PlayerState

## Crouch State
## Player is crouching (avoiding high attacks or reducing hitbox)

var crouch_speed_multiplier: float = 0.5  # Move slower while crouching


func _state_enter() -> void:
	# TODO: Reduce collision shape height
	# TODO: Play crouch animation
	# TODO: Adjust sprite offset
	pass


func _state_physics_update(delta: float) -> void:
	# Apply gravity
	apply_gravity(delta)

	# Handle horizontal movement (slower while crouching)
	var target_velocity = player.input_direction.x * player.SPEED * crouch_speed_multiplier

	if player.input_direction.x != 0:
		player.velocity.x = move_toward(player.velocity.x, target_velocity, player.ACCELERATION * delta)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.FRICTION * delta)

	# Update facing direction
	if player.input_direction.x != 0:
		player.facing_right = player.input_direction.x > 0

	# Flip sprite
	if player.sprite:
		player.sprite.flip_h = not player.facing_right

	# Check transitions
	check_transitions()


func _state_exit() -> void:
	# TODO: Restore collision shape height
	# TODO: Restore sprite offset
	pass


func check_transitions() -> void:
	# If crouch button released
	if not Input.is_action_pressed("crouch"):
		if player.is_on_floor():
			if player.input_direction.x != 0:
				state_machine.change_state("Walk")
			else:
				state_machine.change_state("Idle")
		else:
			state_machine.change_state("Fall")
		return

	# If attack while crouching (crouch attack)
	if Input.is_action_just_pressed("attack") and not player.is_attacking:
		# For now, just do normal attack
		state_machine.change_state("Attack")
		return

	# Can't crouch in air
	if not player.is_on_floor():
		state_machine.change_state("Fall")
		return

	# If dead
	if player.is_dead:
		state_machine.change_state("Death")
		return
