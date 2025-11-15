extends Enemy
class_name EnemyWolf

## Wolf Enemy
## Aggressive enemy that chases and attacks player
## Fast and deadly

func _ready() -> void:
	# Wolf stats (fast, aggressive)
	max_health = 40
	current_health = max_health
	move_speed = 200.0
	patrol_speed = 120.0
	chase_speed = 300.0  # Very fast
	attack_damage = 12  # REBALANCED: 12 dmg (was 15) - balanced for early-mid game
	attack_range = 70.0
	detection_range = 500.0  # Detects from far
	lose_player_range = 800.0
	patrol_distance = 250.0
	patrol_wait_time = 1.0
	attack_cooldown = 1.2  # Attacks frequently

	# Wolf can jump (agile predator)
	can_jump = true
	jump_velocity = -450.0  # Good jump height
	max_jump_distance = 180.0  # Can jump decent gaps

	super._ready()


func _ai_chase(delta: float) -> void:
	"""Wolf is more aggressive in chase (UPDATED for decoupled base class)"""
	# Check if target is still valid
	if not target or (target.has_method("is_dead") and target.is_dead):
		change_state(State.IDLE)
		return

	# Wolves don't give up easily
	if not _is_target_in_range(lose_player_range):
		target_lost.emit()
		target = null
		change_state(State.PATROL)
		return

	# Check if in attack range
	if _is_target_in_range(attack_range) and can_attack:
		change_state(State.ATTACK)
		return

	# Check for edges (wolves will jump aggressively)
	if _check_edge_ahead():
		if can_jump and _can_jump_gap():
			velocity.y = jump_velocity
			print("%s jumping to chase target" % name)

	# Chase with increased speed when close
	var distance_to_target = global_position.distance_to(target.global_position)
	var speed_multiplier = 1.2 if distance_to_target < 200 else 1.0

	var direction = sign(target.global_position.x - global_position.x)
	velocity.x = direction * chase_speed * speed_multiplier
	_update_sprite_direction()


func _perform_attack() -> void:
	"""Wolf lunges at target (UPDATED for decoupled base class)"""
	# Lunge forward only if target exists
	if target:
		var direction = sign(target.global_position.x - global_position.x)
		velocity.x = direction * 400.0  # Lunge speed

	super._perform_attack()
