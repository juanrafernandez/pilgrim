extends PlayerState

## Idle State
## Player is standing still on the ground


func _state_enter() -> void:
	player.velocity.x = 0


func _state_physics_update(delta: float) -> void:
	# Apply gravity
	apply_gravity(delta)

	# Apply friction
	player.velocity.x = move_toward(player.velocity.x, 0, player.FRICTION * delta)

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

	# If moving, go to Walk
	if player.input_direction.x != 0:
		state_machine.change_state("Walk")
		return

	# If jump pressed, go to Jump
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		state_machine.change_state("Jump")
		return

	# If attack pressed, go to Attack
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
