extends PlayerState

## Block State
## Player is blocking with shield
## - Consumes shield energy while blocking
## - Reduces incoming damage by 75%
## - Perfect parry window (0.2s at start) returns damage to attacker
## - Can block on ground or in air

# State tracking
var block_duration: float = 0.0


func _state_enter() -> void:
	block_duration = 0.0

	# Try to start blocking
	if player.shield and player.shield.start_block():
		print("StateBlock: Entered blocking state")
	else:
		# Can't block (no energy), return to previous state
		print("StateBlock: Cannot block - no shield energy")
		_exit_to_appropriate_state()


func _state_exit() -> void:
	# Stop blocking when exiting state
	if player.shield:
		player.shield.stop_block()
	print("StateBlock: Exited blocking state")


func _state_physics_update(delta: float) -> void:
	block_duration += delta

	# Update shield (handles energy consumption)
	if player.shield:
		player.shield.update(delta)

	# Apply gravity
	apply_gravity(delta)

	# Reduced movement while blocking
	if player.is_on_floor():
		# Can move slowly while blocking on ground
		apply_movement(player.input_direction.x * 0.3, delta)
	else:
		# Very limited air control while blocking
		apply_movement(player.input_direction.x * 0.2, delta)

	# Update sprite direction (can turn while blocking)
	if player.input_direction.x != 0:
		update_sprite_direction()

	# Check transitions
	check_transitions()


func check_transitions() -> void:
	# Death takes priority
	if player.is_dead:
		state_machine.change_state("Death")
		return

	# Check if shield depleted
	if player.shield and not player.shield.can_block():
		print("StateBlock: Shield depleted, exiting block")
		_exit_to_appropriate_state()
		return

	# Check if player released block button
	if not Input.is_action_pressed("block"):
		print("StateBlock: Block released")
		_exit_to_appropriate_state()
		return

	# Can't block while attacking
	if player.is_attacking:
		_exit_to_appropriate_state()
		return


func _exit_to_appropriate_state() -> void:
	"""Exit to the appropriate state based on current conditions"""
	if player.is_on_floor():
		if player.input_direction.x != 0:
			state_machine.change_state("Walk")
		else:
			state_machine.change_state("Idle")
	else:
		if player.velocity.y > 0:
			state_machine.change_state("Fall")
		else:
			state_machine.change_state("Jump")
