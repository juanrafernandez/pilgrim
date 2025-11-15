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
	attack_damage = 3  # REBALANCED: 3 dmg (was 5) - less punishing for Child phase
	attack_range = 50.0
	detection_range = 500.0  # Increased to react from farther away
	patrol_distance = 150.0
	patrol_wait_time = 3.0

	# Cow cannot jump (heavy, passive animal)
	can_jump = false
	edge_check_distance = 60.0  # Check farther ahead (cow needs more warning)

	super._ready()


func _check_edge_in_direction(direction: int) -> bool:
	"""Check if there's an edge ahead in a specific direction (1 for right, -1 for left)"""
	if not is_on_floor():
		return false

	# Check position ahead in the specified direction
	var check_position = global_position + Vector2(edge_check_distance * direction, 0)

	# Raycast down to check for ground
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		check_position,
		check_position + Vector2(0, 100)  # Check 100 pixels down
	)
	query.collision_mask = 2  # Ground layer
	query.collide_with_areas = false
	query.collide_with_bodies = true

	var result = space_state.intersect_ray(query)

	# If no ground detected, there's an edge
	var has_edge = result.is_empty()
	if has_edge:
		print("%s: EDGE DETECTED %s pixels ahead (direction: %d)" % [name, edge_check_distance, direction])
	return has_edge


func _ai_idle(delta: float) -> void:
	"""Cow idle behavior - check edges even while idle"""
	velocity.x = move_toward(velocity.x, 0, move_speed * delta * 5)

	# Even while idle, check if we're near an edge in our facing direction
	if is_on_floor():
		var check_dir = 1 if facing_right else -1
		if _check_edge_in_direction(check_dir):
			print("%s: Edge detected while idle, stepping back" % name)
			# Step back from edge by turning around
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

	# Calculate intended movement direction
	var intended_direction = sign(patrol_target.x - global_position.x)

	# CRITICAL: Check for edges in INTENDED direction FIRST (cow can't jump!)
	if _check_edge_in_direction(int(intended_direction)):
		print("%s: Edge ahead in patrol direction, turning around" % name)
		# Turn around immediately - this is top priority
		facing_right = not facing_right
		if sprite:
			sprite.scale.x = 1.0 if facing_right else -1.0
		# Reset patrol target to avoid going that direction
		patrol_target = Vector2.ZERO
		change_state(State.IDLE)
		return

	# Safe to move - no edge ahead
	velocity.x = intended_direction * patrol_speed
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

	# Calculate flee direction (AWAY from player)
	var flee_direction = -sign(player.global_position.x - global_position.x)

	# CRITICAL: Check for edges in FLEE direction (top priority - cow can't jump!)
	if _check_edge_in_direction(int(flee_direction)):
		print("%s: Edge ahead while fleeing! Cow is cornered." % name)

		# If cornered between player and edge, stop and face player (prepare to panic)
		if _is_player_in_range(attack_range * 2.0):
			velocity.x = 0
			# Face the player
			facing_right = player.global_position.x > global_position.x
			if sprite:
				sprite.scale.x = 1.0 if facing_right else -1.0
			print("%s: Cornered! Stopping and facing player." % name)
			return
		else:
			# Not too close yet, try moving perpendicular to edge (stay on platform)
			velocity.x = 0
			print("%s: Edge ahead but not cornered, stopping" % name)
			return

	# Safe to flee - no edge ahead
	velocity.x = flee_direction * chase_speed
	_update_sprite_direction()

	# If cornered and player too close, panic attack
	if _is_player_in_range(attack_range * 0.7) and can_attack:
		change_state(State.ATTACK)


func _perform_attack() -> void:
	"""Cow does weak panic attack when cornered"""
	super._perform_attack()
	print("%s panicked and attacked!" % name)
