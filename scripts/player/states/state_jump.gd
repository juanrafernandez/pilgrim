extends PlayerState

## Jump State
## Player is jumping upwards


func _state_enter() -> void:
	player.velocity.y = player.JUMP_VELOCITY
	print("Jump!")


func _state_physics_update(delta: float) -> void:
	# Apply gravity
	apply_gravity(delta)

	# Apply horizontal movement (air control)
	apply_movement(player.input_direction.x, delta)

	# Update sprite direction
	update_sprite_direction()

	# Check transitions
	check_transitions()


func check_transitions() -> void:
	# If throw projectile pressed
	if Input.is_action_just_pressed("special"):
		player.throw_projectile()

	# If falling, go to Fall
	if player.velocity.y > 0:
		state_machine.change_state("Fall")
		return

	# If attack pressed in air, go to Attack
	if Input.is_action_just_pressed("attack") and not player.is_attacking:
		state_machine.change_state("Attack")
		return

	# If dead, go to Death
	if player.is_dead:
		state_machine.change_state("Death")
		return
