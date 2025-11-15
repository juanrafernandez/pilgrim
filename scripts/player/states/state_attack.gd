extends PlayerState

## Attack State
## Player is performing an attack

var attack_timer: float = 0.0


func _state_enter() -> void:
	attack_timer = 0.0
	player.attack()  # Trigger attack

	# Play attack animation
	if player.sprite:
		player.sprite.play("attack")


func _state_physics_update(delta: float) -> void:
	attack_timer += delta

	# Apply gravity
	apply_gravity(delta)

	# Reduce movement during attack
	if player.is_on_floor():
		player.velocity.x = move_toward(player.velocity.x, 0, player.FRICTION * 2.0 * delta)
	else:
		# Slight air control during attack
		apply_movement(player.input_direction.x * 0.5, delta)

	# Check transitions
	check_transitions()


func check_transitions() -> void:
	# If attack finished, return to appropriate state
	if attack_timer >= player.ATTACK_DURATION:
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
		return

	# If dead, go to Death
	if player.is_dead:
		state_machine.change_state("Death")
		return
