extends Enemy
class_name EnemyWolf

## Wolf Enemy
## Aggressive predator that chases and attacks player tenaciously
## Fast and deadly with complex chase behavior

# Wolf-specific variables
var chase_timer: float = 0.0  # Timer for CHASE state (5 seconds)
const CHASE_DURATION: float = 5.0  # How long wolf chases before going to RELAX
var en_relax: bool = false  # Flag for RELAX state (tired after chasing)
var relax_timer: float = 0.0  # Timer for RELAX state (5 seconds)
const RELAX_DURATION: float = 5.0  # How long wolf rests

# Inertia system (when player jumps over wolf)
var inertia_mode: bool = false  # Wolf continues in direction for ~70px
var inertia_distance_traveled: float = 0.0  # Distance traveled in inertia
const INERTIA_DISTANCE: float = 70.0  # Wolf's length in pixels
var inertia_last_position: Vector2 = Vector2.ZERO

# Contact cooldown (prevent immediate re-contact after recoil)
var contact_immunity_timer: float = 0.0  # Prevents contact immediately after recoil
const CONTACT_IMMUNITY_DURATION: float = 0.6  # Can't contact for 0.6s after recoil ends


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

	# WOLF-SPECIFIC: Random initial state (50% IDLE, 50% PATROL)
	if randf() < 0.5:
		change_state(State.IDLE)
		print("%s: Starting in IDLE" % name)
	else:
		change_state(State.PATROL)
		print("%s: Starting in PATROL" % name)


func change_state(new_state: State) -> void:
	"""Override to initialize chase timer when entering CHASE (WOLF-SPECIFIC)"""
	var old_state = current_state
	super.change_state(new_state)

	# Initialize chase timer when entering CHASE from non-CHASE state
	if new_state == State.CHASE and old_state != State.CHASE:
		chase_timer = CHASE_DURATION
		print("%s: Entering CHASE, timer set to %.1fs" % [name, CHASE_DURATION])


func _physics_process(delta: float) -> void:
	# Update contact immunity timer
	if contact_immunity_timer > 0:
		contact_immunity_timer -= delta

	# Handle RELAX state (wolf-specific, not in base Enemy)
	if en_relax:
		_ai_relax(delta)
		# Still apply gravity and movement
		if not is_on_floor():
			velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta
		move_and_slide()
		return

	# WOLF-SPECIFIC: Handle recoil completely (don't let parent handle it)
	if is_recoiling:
		recoil_timer -= delta
		if recoil_timer <= 0:
			# Recoil just finished - activate immunity period
			is_recoiling = false
			velocity.x = 0  # CRITICAL: Reset velocity to stop backward movement
			contact_immunity_timer = CONTACT_IMMUNITY_DURATION
			print("%s: Recoil finished, velocity reset, immunity active for %.1fs" % [name, CONTACT_IMMUNITY_DURATION])
		else:
			# Still recoiling - slow down the velocity
			velocity.x = move_toward(velocity.x, 0, move_speed * delta * 3)

		# Apply gravity and movement during recoil
		if not is_on_floor():
			velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta
		move_and_slide()
		return  # Don't call parent - we handled everything

	# Update chase timer if in CHASE state
	if current_state == State.CHASE:
		chase_timer -= delta
		if chase_timer <= 0:
			# Timer expired without contact - go to RELAX
			print("%s: CHASE timer expired, going to RELAX" % name)
			en_relax = true
			relax_timer = RELAX_DURATION
			target = null
			change_state(State.IDLE)
			return

	# Call parent physics process (only if not recoiling)
	super._physics_process(delta)


func _ai_relax(delta: float) -> void:
	"""RELAX state - wolf rests for 5 seconds after chasing without contact"""
	# Slow down to stop
	velocity.x = move_toward(velocity.x, 0, move_speed * delta * 5)

	# Update timer
	relax_timer -= delta
	if relax_timer <= 0:
		# RELAX finished - check if player nearby
		en_relax = false
		print("%s: RELAX finished" % name)

		# Look for player in detection range
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsShapeQueryParameters2D.new()
		var shape = CircleShape2D.new()
		shape.radius = detection_range
		query.shape = shape
		query.transform = global_transform
		query.collision_mask = 1  # Player layer
		query.collide_with_areas = false
		query.collide_with_bodies = true

		var results = space_state.intersect_shape(query, 1)
		if results.size() > 0:
			var body = results[0].collider
			if body.is_in_group("player") and body.has_method("take_damage"):
				if not (body.has_method("is_dead") and body.is_dead):
					# Player nearby - go to CHASE
					target = body
					chase_timer = CHASE_DURATION
					change_state(State.CHASE)
					print("%s: Player detected after RELAX, chasing again" % name)
					return

		# No player nearby - go to PATROL
		change_state(State.PATROL)
		print("%s: No player after RELAX, going to PATROL" % name)


func _ai_chase(delta: float) -> void:
	"""Wolf chases aggressively with inertia when player jumps over (WOLF-SPECIFIC)"""
	# WOLF-SPECIFIC: Reset any residual backward velocity when entering chase
	# (prevents backward drift after ATTACK state)
	if velocity.x < 0 and target and target.global_position.x > global_position.x:
		# Moving left but target is to the right - reset
		velocity.x = 0
	elif velocity.x > 0 and target and target.global_position.x < global_position.x:
		# Moving right but target is to the left - reset
		velocity.x = 0

	# Check if target is still valid
	if not target or (target.has_method("is_dead") and target.is_dead):
		chase_timer = 0
		change_state(State.IDLE)
		return

	# Check if target is too far (lose player)
	if not _is_target_in_range(lose_player_range):
		print("%s: Target too far, lost player" % name)
		chase_timer = 0
		target = null
		change_state(State.PATROL)
		return

	# Check if in attack range
	if _is_target_in_range(attack_range) and can_attack:
		change_state(State.ATTACK)
		return

	# INERTIA SYSTEM: When player jumps over wolf
	var direction_to_target = sign(target.global_position.x - global_position.x)
	var facing_direction = 1 if facing_right else -1
	var target_is_behind = (direction_to_target != facing_direction)
	var target_in_air = target.has_method("is_on_floor") and not target.is_on_floor()

	# Start inertia mode if target jumps behind us
	if target_is_behind and target_in_air and not inertia_mode:
		inertia_mode = true
		inertia_distance_traveled = 0.0
		inertia_last_position = global_position
		print("%s: Player jumped over, entering INERTIA mode" % name)

	# Update inertia distance if in inertia mode
	if inertia_mode:
		inertia_distance_traveled += global_position.distance_to(inertia_last_position)
		inertia_last_position = global_position

		# Exit inertia if traveled enough distance OR target landed
		if inertia_distance_traveled >= INERTIA_DISTANCE or not target_in_air:
			inertia_mode = false
			inertia_distance_traveled = 0.0
			print("%s: INERTIA finished (traveled %.0fpx), recalculating direction" % [name, inertia_distance_traveled])

	# Check for edges (wolves will jump aggressively)
	if _check_edge_ahead():
		if can_jump and _can_jump_gap():
			velocity.y = jump_velocity
			print("%s jumping to chase target" % name)
		else:
			# Can't jump the gap
			if _is_target_in_range(detection_range):
				# Player nearby but can't reach - give up and patrol
				print("%s: Can't jump gap, player nearby but blocked - going to PATROL" % name)
				target = null
				chase_timer = 0
				change_state(State.PATROL)
				return
			else:
				# Player far - just go to patrol
				print("%s: Can't jump gap, player far - going to PATROL" % name)
				target = null
				chase_timer = 0
				change_state(State.PATROL)
				return

	# Calculate movement direction
	var direction: int
	if inertia_mode:
		# Continue in current direction (don't recalculate)
		direction = facing_direction
		print("%s: INERTIA mode - continuing direction %d" % [name, direction])
	else:
		# Normal chase - move towards target
		direction = sign(target.global_position.x - global_position.x)

	# Chase with increased speed when close
	var distance_to_target = global_position.distance_to(target.global_position)
	var speed_multiplier = 1.2 if distance_to_target < 200 else 1.0

	velocity.x = direction * chase_speed * speed_multiplier
	_update_sprite_direction()


func _perform_attack() -> void:
	"""Wolf lunges at target (UPDATED for decoupled base class)"""
	# Lunge forward only if target exists
	if target:
		var direction = sign(target.global_position.x - global_position.x)
		velocity.x = direction * 400.0  # Lunge speed

	super._perform_attack()

	# NOTE: ATTACK does NOT reset chase timer (only contact does)


func _on_body_entered_contact(body: Node2D) -> void:
	"""WOLF-SPECIFIC contact behavior - stays in CHASE after contact (different from base Enemy)"""
	print(">>> [%s] body_entered_contact called | is_recoiling=%s | immunity=%.2f" % [name, is_recoiling, contact_immunity_timer])

	# Duck typing: check if body can take damage and is in player group
	if not body.has_method("take_damage") or not body.is_in_group("player"):
		print(">>> [%s] SKIP: Not player" % name)
		return

	# Check if target is dead using duck typing
	if (body.has_method("is_dead") and body.is_dead) or is_dead:
		print(">>> [%s] SKIP: Dead" % name)
		return

	# Don't trigger contact damage while already recoiling (prevents multiple bounces)
	if is_recoiling:
		print(">>> [%s] SKIP: Already recoiling" % name)
		return

	# WOLF-SPECIFIC: Don't trigger contact if in immunity period after previous recoil
	if contact_immunity_timer > 0:
		print(">>> [%s] SKIP: Immunity active (%.2fs remaining)" % [name, contact_immunity_timer])
		return

	# Only deal contact damage in CHASE state (wolf-specific)
	if current_state != State.CHASE:
		print(">>> [%s] SKIP: Not in CHASE state (state=%d)" % [name, current_state])
		return

	# Check if enough time has passed since last contact damage
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_contact_damage_time >= contact_damage_cooldown:
		print(">>> [%s] *** CONTACT DAMAGE TRIGGERED ***" % name)
		# Deal contact damage
		var knockback_dir = sign(body.global_position.x - global_position.x)
		var knockback = Vector2(knockback_dir * 250, -350)  # Softer than attacks
		body.take_damage(contact_damage, knockback, self)
		last_contact_damage_time = current_time

		# Enemy recoils with a short bounce
		var enemy_recoil_dir = -knockback_dir  # Opposite direction
		var enemy_recoil_velocity = enemy_recoil_dir * 300.0  # Stronger recoil to separate from player

		# Apply recoil impulse and activate recoil state
		velocity.x = enemy_recoil_velocity
		is_recoiling = true
		recoil_timer = 0.4  # Longer cooldown (0.4s instead of 0.15s)

		# WOLF-SPECIFIC: Reset chase timer and STAY in CHASE (don't go to PATROL)
		chase_timer = CHASE_DURATION
		# DON'T set return_to_patrol_after_recoil (wolf stays in chase)

		# Exit inertia mode on contact
		inertia_mode = false
		inertia_distance_traveled = 0.0

		# Lighter screenshake for contact damage (duck typing check for camera)
		if body.has_method("get") and body.get("camera_controller"):
			body.camera_controller.add_trauma(0.2)  # Lighter shake than normal hits

		print("%s dealt %d contact damage, recoiled, CHASE timer reset to %.1fs - STAYING in CHASE" % [name, contact_damage, CHASE_DURATION])
