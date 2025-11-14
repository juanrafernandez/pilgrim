extends Enemy
class_name EnemyGoat

## Goat Enemy
## Aggressive animal that attacks when player is near
## Can be pushed back and will flee after 2 hits
## Etapa: Niñez y Adolescencia

var hit_count: int = 0  # Track hits received
var is_fleeing: bool = false

func _ready() -> void:
	# Goat stats (aggressive, medium)
	max_health = 40
	current_health = max_health
	move_speed = 140.0
	patrol_speed = 90.0
	chase_speed = 220.0  # Fast when attacking
	attack_damage = 15  # 15% damage
	attack_range = 60.0
	detection_range = 350.0
	patrol_distance = 180.0
	patrol_wait_time = 2.0
	attack_cooldown = 1.5

	# Goat can jump (agile animal)
	can_jump = true
	jump_velocity = -420.0
	max_jump_distance = 160.0

	super._ready()


func take_damage(amount: int, knockback_direction: Vector2 = Vector2.ZERO) -> void:
	"""Goat gets pushed back and flees after 2 hits"""
	hit_count += 1

	# After 2 hits, goat starts fleeing
	if hit_count >= 2:
		is_fleeing = true
		player = null  # Stop tracking player
		print("%s is fleeing after %d hits!" % [name, hit_count])

	super.take_damage(amount, knockback_direction)


func _ai_chase(delta: float) -> void:
	"""Goat chases aggressively unless fleeing"""
	# If fleeing, run away
	if is_fleeing:
		_ai_flee(delta)
		return

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

	# Check for edges
	if _check_edge_ahead():
		if can_jump and _can_jump_gap():
			velocity.y = jump_velocity
			print("%s jumping to attack player" % name)

	# Chase player aggressively
	var direction = sign(player.global_position.x - global_position.x)
	velocity.x = direction * chase_speed
	_update_sprite_direction()


func _ai_flee(delta: float) -> void:
	"""Flee behavior - run away from spawn point direction"""
	# Run away from spawn position
	var direction_from_spawn = sign(global_position.x - spawn_position.x)

	# If at edge, just stop
	if _check_edge_ahead():
		velocity.x = 0
		return

	velocity.x = direction_from_spawn * chase_speed * 1.2  # Run fast
	_update_sprite_direction()

	# If far enough from spawn, calm down and patrol
	if global_position.distance_to(spawn_position) > patrol_distance * 2:
		is_fleeing = false
		hit_count = 0
		change_state(State.PATROL)
		print("%s stopped fleeing" % name)


func _perform_attack() -> void:
	"""Goat headbutts player"""
	# Headbutt with forward movement
	var direction = sign(player.global_position.x - global_position.x)
	velocity.x = direction * 300.0

	super._perform_attack()
	print("%s headbutted player!" % name)
