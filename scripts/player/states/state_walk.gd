extends PlayerState

## Walk State
## Player is moving horizontally on the ground


func _state_enter() -> void:
	# Play walk animation
	if player.sprite:
		player.sprite.play("walk")


func _state_physics_update(delta: float) -> void:
	# Apply gravity
	apply_gravity(delta)

	# Apply horizontal movement
	apply_movement(player.input_direction.x, delta)

	# Update sprite direction
	update_sprite_direction()

	# Check transitions
	check_transitions()


func check_transitions() -> void:
	# If throw projectile pressed
	if Input.is_action_just_pressed("special"):
		player.throw_projectile()

	# If stopped moving, go to Idle
	if player.input_direction.x == 0:
		state_machine.change_state("Idle")
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
