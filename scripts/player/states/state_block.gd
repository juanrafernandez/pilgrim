extends PlayerState

## Block State
## Player is blocking with shield

var block_duration: float = 0.0
var max_block_duration: float = 2.0  # Maximum time player can hold block


func _state_enter() -> void:
	block_duration = 0.0
	player.velocity.x = 0
	# TODO: Activate shield visual effect
	# TODO: Play block sound


func _state_physics_update(delta: float) -> void:
	block_duration += delta

	# Apply gravity
	apply_gravity(delta)

	# Block slows down player
	player.velocity.x = move_toward(player.velocity.x, 0, player.FRICTION * delta)

	# Check transitions
	check_transitions()


func _state_exit() -> void:
	# TODO: Deactivate shield visual effect
	pass


func check_transitions() -> void:
	# If block button released
	if not Input.is_action_pressed("block"):
		if player.is_on_floor():
			if player.input_direction.x != 0:
				state_machine.change_state("Walk")
			else:
				state_machine.change_state("Idle")
		else:
			state_machine.change_state("Fall")
		return

	# If max block duration reached (stamina depleted)
	if block_duration >= max_block_duration:
		if player.is_on_floor():
			state_machine.change_state("Idle")
		else:
			state_machine.change_state("Fall")
		return

	# If in air, can't block
	if not player.is_on_floor():
		state_machine.change_state("Fall")
		return

	# If dead
	if player.is_dead:
		state_machine.change_state("Death")
		return
