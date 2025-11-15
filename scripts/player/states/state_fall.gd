extends PlayerState

## Fall State
## Player is falling downwards


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
	# If block pressed and can block, go to Block
	if Input.is_action_just_pressed("block") and player.can_block():
		state_machine.change_state("Block")
		return

	# If throw projectile pressed
	if Input.is_action_just_pressed("special"):
		player.throw_projectile()

	# If landed, go to Idle or Walk
	if player.is_on_floor():
		if player.input_direction.x != 0:
			state_machine.change_state("Walk")
		else:
			state_machine.change_state("Idle")
		return

	# If attack pressed in air, go to Attack
	if Input.is_action_just_pressed("attack") and not player.is_attacking:
		state_machine.change_state("Attack")
		return

	# If dead, go to Death
	if player.is_dead:
		state_machine.change_state("Death")
		return
