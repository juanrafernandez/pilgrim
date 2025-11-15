extends CharacterBody2D
class_name Enemy

## Base Enemy Class
## All enemies inherit from this class
## Handles health, damage, movement, and basic AI

# Signals
signal health_changed(new_health: int, max_health: int)
signal died()
signal player_detected(player: Player)
signal player_lost()
signal attacked(target: Node2D)

# Enums
enum State {
	IDLE,
	PATROL,
	CHASE,
	ATTACK,
	HURT,
	DEATH
}

# Enemy stats (override in child classes)
var max_health: int = 50
var current_health: int = 50
var move_speed: float = 150.0
var patrol_speed: float = 100.0
var chase_speed: float = 200.0
var attack_damage: int = 10
var contact_damage: int = 0  # Damage on collision (0 = auto-calculate as 70% of attack_damage)
var attack_range: float = 60.0
var detection_range: float = 400.0
var lose_player_range: float = 600.0
var score_value: int = 100  # Points awarded when killed

# Movement capabilities
var can_jump: bool = false  # Can this enemy jump?
var jump_velocity: float = -400.0  # Jump strength
var max_jump_distance: float = 150.0  # Max horizontal distance enemy can jump
var edge_check_distance: float = 50.0  # How far ahead to check for edges

# Attack behavior
var attack_knockback_self: float = 250.0  # Enemy recoils after attacking
var attack_duration: float = 0.4  # How long attack state lasts
var contact_damage_cooldown: float = 0.5  # Damage cooldown for contact hits (adjusted per enemy type)
var contact_damage_cooldown_early_game: float = 0.75  # Longer cooldown for early game (child phase)
var contact_damage_cooldown_late_game: float = 0.5  # Shorter cooldown for late game (knight phase)

# State
var current_state: State = State.IDLE
var is_dead: bool = false
var facing_right: bool = true

# AI behavior
var patrol_distance: float = 200.0
var patrol_wait_time: float = 2.0
var attack_cooldown: float = 1.5
var can_attack: bool = true
var attack_state_timer: float = 0.0

# References
var player: Player = null
var spawn_position: Vector2
var patrol_target: Vector2
var patrol_timer: float = 0.0
var attack_timer: float = 0.0

# Nodes (to be set by child classes or scene)
@onready var sprite: AnimatedSprite2D = $Sprite if has_node("Sprite") else null
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var detection_area: Area2D = $DetectionArea if has_node("DetectionArea") else null
@onready var contact_area: Area2D = $ContactArea if has_node("ContactArea") else null

# Contact damage tracking
var last_contact_damage_time: float = 0.0


func _ready() -> void:
	add_to_group("enemies")  # Add to enemies group for level management
	spawn_position = global_position
	current_health = max_health

	# Auto-calculate contact damage if not set (70% of attack damage)
	if contact_damage == 0:
		contact_damage = int(attack_damage * 0.7)

	# Adjust contact damage cooldown based on enemy difficulty
	_adjust_contact_cooldown()

	_setup_detection_area()
	_setup_contact_area()
	print("%s spawned at %s (Attack: %d, Contact: %d, Cooldown: %.2fs)" % [name, spawn_position, attack_damage, contact_damage, contact_damage_cooldown])


func _physics_process(delta: float) -> void:
	if is_dead:
		return

	# Update timers
	if patrol_timer > 0:
		patrol_timer -= delta
	if attack_timer > 0:
		attack_timer -= delta
		can_attack = attack_timer <= 0
	if attack_state_timer > 0:
		attack_state_timer -= delta

	# AI behavior based on state
	_update_ai(delta)

	# Apply gravity
	if not is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta

	# Move
	move_and_slide()


func _setup_detection_area() -> void:
	"""Setup detection area if it exists"""
	if detection_area:
		detection_area.body_entered.connect(_on_body_entered_detection)
		detection_area.body_exited.connect(_on_body_exited_detection)


func _adjust_contact_cooldown() -> void:
	"""Adjust contact damage cooldown based on enemy difficulty (early vs late game)"""
	# Early game enemies (≤12 damage): Longer cooldown for beginner-friendly gameplay
	# Late game enemies (≥22 damage): Normal cooldown for skilled players
	if attack_damage <= 12:
		contact_damage_cooldown = contact_damage_cooldown_early_game  # 0.75s
	elif attack_damage >= 22:
		contact_damage_cooldown = contact_damage_cooldown_late_game  # 0.5s
	else:
		# Mid-game: Interpolate between early and late (12-22 damage range)
		var t = (attack_damage - 12.0) / (22.0 - 12.0)  # 0.0 to 1.0
		contact_damage_cooldown = lerp(contact_damage_cooldown_early_game, contact_damage_cooldown_late_game, t)


func _setup_contact_area() -> void:
	"""Setup contact area for collision damage"""
	if contact_area:
		contact_area.body_entered.connect(_on_body_entered_contact)
		contact_area.body_exited.connect(_on_body_exited_contact)


func _update_ai(delta: float) -> void:
	"""Update AI behavior - override in child classes for custom behavior"""
	match current_state:
		State.IDLE:
			_ai_idle(delta)
		State.PATROL:
			_ai_patrol(delta)
		State.CHASE:
			_ai_chase(delta)
		State.ATTACK:
			_ai_attack(delta)
		State.HURT:
			_ai_hurt(delta)
		State.DEATH:
			_ai_death(delta)


func _ai_idle(delta: float) -> void:
	"""Idle behavior"""
	velocity.x = move_toward(velocity.x, 0, move_speed * delta * 5)

	# Check for player in range
	if player and _is_player_in_range(detection_range):
		change_state(State.CHASE)
	elif patrol_timer <= 0:
		change_state(State.PATROL)


func _ai_patrol(delta: float) -> void:
	"""Patrol behavior"""
	# Set patrol target if not set
	if patrol_target == Vector2.ZERO:
		_set_random_patrol_target()

	# Check for edges before moving
	_handle_edge_behavior()

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
	"""Chase player behavior"""
	if not player or player.is_dead:
		change_state(State.IDLE)
		return

	# Check if player is too far
	if not _is_player_in_range(lose_player_range):
		player_lost.emit()
		player = null
		change_state(State.PATROL)
		return

	# Check if in attack range
	if _is_player_in_range(attack_range) and can_attack:
		change_state(State.ATTACK)
		return

	# Check for edges before moving (but be more aggressive when chasing)
	if _check_edge_ahead():
		if can_jump:
			# Try to jump if chasing player
			if _can_jump_gap():
				velocity.y = jump_velocity
				print("%s jumping to chase player" % name)
		else:
			# If can't jump and edge ahead, stop chasing
			change_state(State.IDLE)
			return

	# Move towards player
	var direction = sign(player.global_position.x - global_position.x)
	velocity.x = direction * chase_speed
	_update_sprite_direction()


func _ai_attack(delta: float) -> void:
	"""Attack behavior with knockback"""
	# First frame of attack: perform attack and apply self-knockback
	if attack_state_timer <= 0:
		if not player or player.is_dead:
			change_state(State.IDLE)
			return

		# Perform attack
		_perform_attack()

		# Enemy recoils backward after attacking
		var recoil_dir = -sign(player.global_position.x - global_position.x)
		velocity.x = recoil_dir * attack_knockback_self

		# Set attack duration
		attack_state_timer = attack_duration

	# During attack animation, gradually slow down
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed * delta * 8)

	# After attack duration ends, return to chase
	if attack_state_timer <= 0:
		attack_timer = attack_cooldown
		can_attack = false
		change_state(State.CHASE)


func _ai_hurt(delta: float) -> void:
	"""Hurt behavior - brief stun"""
	velocity.x = move_toward(velocity.x, 0, move_speed * delta * 10)
	# Hurt state handled by timer in take_damage()


func _ai_death(delta: float) -> void:
	"""Death behavior"""
	velocity.x = 0


func _set_random_patrol_target() -> void:
	"""Set a random patrol target around spawn position"""
	var offset = randf_range(-patrol_distance, patrol_distance)
	patrol_target = spawn_position + Vector2(offset, 0)


func _is_player_in_range(range: float) -> bool:
	"""Check if player is within range"""
	if not player:
		return false
	return global_position.distance_to(player.global_position) <= range


func _update_sprite_direction() -> void:
	"""Update sprite facing direction"""
	if sprite and velocity.x != 0:
		facing_right = velocity.x > 0
		sprite.scale.x = 1.0 if facing_right else -1.0


func _check_edge_ahead() -> bool:
	"""Check if there's an edge/cliff ahead using raycast"""
	if not is_on_floor():
		return false

	# Check direction enemy is moving
	var direction = 1 if facing_right else -1
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
	return result.is_empty()


func _can_jump_gap() -> bool:
	"""Check if enemy can jump across the gap ahead"""
	if not can_jump:
		return false

	# Check if gap is within jumpable distance
	var direction = 1 if facing_right else -1

	# Check at max jump distance
	var check_position = global_position + Vector2(max_jump_distance * direction, 0)

	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		check_position,
		check_position + Vector2(0, 100)
	)
	query.collision_mask = 2  # Ground layer

	var result = space_state.intersect_ray(query)

	# If there's ground at jump distance, we can jump
	return not result.is_empty()


func _handle_edge_behavior() -> void:
	"""Handle what to do when edge is detected"""
	if _check_edge_ahead():
		if can_jump and _can_jump_gap():
			# Jump across the gap
			velocity.y = jump_velocity
			print("%s jumping across gap" % name)
		else:
			# Turn around
			facing_right = not facing_right
			if sprite:
				sprite.scale.x = 1.0 if facing_right else -1.0
			velocity.x *= -1  # Reverse direction
			print("%s turning around at edge" % name)


func _perform_attack() -> void:
	"""Perform attack on player with knockback"""
	if player and _is_player_in_range(attack_range):
		# Calculate knockback direction (away from enemy)
		var knockback_dir = sign(player.global_position.x - global_position.x)
		var knockback = Vector2(knockback_dir * 350, -450)  # Strong knockback (GnG style)

		player.take_damage(attack_damage, knockback, self)  # Pass self as attacker for parry
		attacked.emit(player)
		print("%s attacked player for %d damage" % [name, attack_damage])


## Take damage
func take_damage(amount: int, knockback_direction: Vector2 = Vector2.ZERO) -> void:
	if is_dead:
		return

	current_health = maxi(0, current_health - amount)
	health_changed.emit(current_health, max_health)

	print("%s took %d damage. Health: %d/%d" % [name, amount, current_health, max_health])

	# Knockback
	if knockback_direction != Vector2.ZERO:
		velocity = knockback_direction * 300.0

	if current_health <= 0:
		die()
	else:
		# Brief hurt state
		var previous_state = current_state
		change_state(State.HURT)
		await get_tree().create_timer(0.3).timeout
		if not is_dead:
			change_state(previous_state)


## Die
func die() -> void:
	if is_dead:
		return

	is_dead = true
	change_state(State.DEATH)
	died.emit()

	print("%s died" % name)

	# Award score to player using new managers (SOLID principle - dependency on abstraction)
	if has_node("/root/ScoreManager"):
		get_node("/root/ScoreManager").add_score(score_value)

	if has_node("/root/ComboManager"):
		get_node("/root/ComboManager").add_combo_hit()

	# Fade out and remove
	_death_animation()


func _death_animation() -> void:
	"""Play death animation and remove enemy"""
	if sprite:
		var tween = create_tween()
		tween.tween_property(sprite, "modulate:a", 0.0, 1.0)
		await tween.finished

	queue_free()


## Set enemy active/inactive state
func set_active(active: bool) -> void:
	"""Enable or disable enemy AI and visibility"""
	set_physics_process(active)
	visible = active

	if not active:
		# Deactivate enemy - set to idle and stop movement
		change_state(State.IDLE)
		velocity = Vector2.ZERO
		player = null
	else:
		# Activate enemy - start patrolling
		change_state(State.PATROL)
		print("%s activated!" % name)


## Change state
func change_state(new_state: State) -> void:
	if current_state == new_state:
		return

	current_state = new_state
	# print("%s: State changed to %s" % [name, State.keys()[new_state]])


## Detection callbacks
func _on_body_entered_detection(body: Node2D) -> void:
	"""Called when body enters detection area"""
	if body is Player and not body.is_dead:
		player = body
		player_detected.emit(player)
		print("%s detected player" % name)


func _on_body_exited_detection(body: Node2D) -> void:
	"""Called when body exits detection area"""
	if body is Player:
		# Don't immediately lose player, wait for chase AI to handle it
		pass


## Contact damage callbacks
func _on_body_entered_contact(body: Node2D) -> void:
	"""Called when body enters contact area (continuous damage on touch)"""
	if body is Player and not body.is_dead and not is_dead:
		# Check if enough time has passed since last contact damage
		var current_time = Time.get_ticks_msec() / 1000.0
		if current_time - last_contact_damage_time >= contact_damage_cooldown:
			# Deal contact damage (70% of attack damage by default)
			# Reduced knockback for contact damage (feels less punishing than attacks)
			var knockback_dir = sign(body.global_position.x - global_position.x)
			var knockback = Vector2(knockback_dir * 250, -350)  # Softer than attacks
			body.take_damage(contact_damage, knockback, self)
			last_contact_damage_time = current_time

			# Lighter screenshake for contact damage (distinct from attack hits)
			if body.has_method("get") and body.camera_controller:
				body.camera_controller.add_trauma(0.2)  # Lighter shake than normal hits

			print("%s dealt %d contact damage to player" % [name, contact_damage])


func _on_body_exited_contact(body: Node2D) -> void:
	"""Called when body exits contact area"""
	# Reset contact damage timer when player leaves
	if body is Player:
		last_contact_damage_time = 0.0
