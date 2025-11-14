extends Enemy
class_name EnemyCow

## Cow Enemy
## Passive enemy that only patrols, doesn't attack
## Runs away when player gets close

func _ready() -> void:
	# Cow stats (weak, passive)
	max_health = 30
	current_health = max_health
	move_speed = 120.0
	patrol_speed = 80.0
	chase_speed = 180.0  # Runs away
	attack_damage = 5  # Minimal damage if cornered
	attack_range = 50.0
	detection_range = 500.0  # Increased to react from farther away
	patrol_distance = 150.0
	patrol_wait_time = 3.0

	# Cow cannot jump (heavy, passive animal)
	can_jump = false

	super._ready()


func _ai_idle(delta: float) -> void:
	"""Cow idle behavior - check edges even while idle"""
	velocity.x = move_toward(velocity.x, 0, move_speed * delta * 5)

	# Even while idle, check if we're near an edge
	if is_on_floor() and _check_edge_ahead():
		# Step back from edge
		facing_right = not facing_right
		if sprite:
			sprite.scale.x = 1.0 if facing_right else -1.0
		# Move away from edge slightly
		velocity.x = (1 if facing_right else -1) * move_speed * 0.3

	# Check for player in range
	if player and _is_player_in_range(detection_range):
		change_state(State.CHASE)
	elif patrol_timer <= 0:
		change_state(State.PATROL)


func _ai_patrol(delta: float) -> void:
	"""Cow patrols carefully, ALWAYS checking edges (can't jump)"""
	# Set patrol target if not set
	if patrol_target == Vector2.ZERO:
		_set_random_patrol_target()

	# CRITICAL: Check for edges FIRST (cow can't jump!)
	if _check_edge_ahead():
		# Turn around immediately - this is top priority
		facing_right = not facing_right
		if sprite:
			sprite.scale.x = 1.0 if facing_right else -1.0
		# Reset patrol target to avoid going that direction
		patrol_target = Vector2.ZERO
		change_state(State.IDLE)
		return

	# Move towards patrol target
	var direction = sign(patrol_target.x - global_position.x)
	velocity.x = direction * patrol_speed
	_update_sprite_direction()

	# Check if reached patrol target
	if abs(patrol_target.x - global_position.x) < 20:
		patrol_timer = patrol_wait_time
		patrol_target = Vector2.ZERO
		change_state(State.IDLE)

	# Check for player
	if player and _is_player_in_range(detection_range):
		change_state(State.CHASE)


func _ai_chase(delta: float) -> void:
	"""Cow runs AWAY from player instead of chasing"""
	if not player or player.is_dead:
		change_state(State.IDLE)
		return

	# Check if player is far enough
	if not _is_player_in_range(detection_range):
		player = null
		change_state(State.PATROL)
		return

	# CRITICAL: Check for edges when fleeing (top priority - cow can't jump!)
	if _check_edge_ahead():
		# Turn around to face away from edge
		facing_right = not facing_right
		if sprite:
			sprite.scale.x = 1.0 if facing_right else -1.0

		# If cornered between player and edge, stop and face player (prepare to panic)
		if _is_player_in_range(attack_range * 2.0):
			velocity.x = 0
			# Face the player
			facing_right = player.global_position.x > global_position.x
			if sprite:
				sprite.scale.x = 1.0 if facing_right else -1.0
			return
		else:
			# Not cornered yet, can move along the edge
			velocity.x = (1 if facing_right else -1) * chase_speed * 0.5
			return

	# Run AWAY from player (opposite direction)
	var direction = -sign(player.global_position.x - global_position.x)
	velocity.x = direction * chase_speed
	_update_sprite_direction()

	# If cornered and player too close, panic attack
	if _is_player_in_range(attack_range * 0.7) and can_attack:
		change_state(State.ATTACK)


func _perform_attack() -> void:
	"""Cow does weak panic attack when cornered"""
	super._perform_attack()
	print("%s panicked and attacked!" % name)
