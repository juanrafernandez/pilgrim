extends PlayerState

## Hurt State
## Player is taking damage

var hurt_duration: float = 0.3
var hurt_timer: float = 0.0


func _state_enter() -> void:
	hurt_timer = 0.0
	# Knockback
	player.velocity.y = -300.0


func _state_physics_update(delta: float) -> void:
	hurt_timer += delta

	# Apply gravity
	apply_gravity(delta)

	# Slight knockback movement
	player.velocity.x = move_toward(player.velocity.x, 0, player.FRICTION * delta)

	# Check transitions
	check_transitions()


func check_transitions() -> void:
	# If hurt duration finished
	if hurt_timer >= hurt_duration:
		if player.is_dead:
			state_machine.change_state("Death")
		elif player.is_on_floor():
			state_machine.change_state("Idle")
		else:
			state_machine.change_state("Fall")
		return
