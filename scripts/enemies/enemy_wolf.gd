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
	attack_damage = 15  # High damage
	attack_range = 70.0
	detection_range = 500.0  # Detects from far
	lose_player_range = 800.0
	patrol_distance = 250.0
	patrol_wait_time = 1.0
	attack_cooldown = 1.2  # Attacks frequently

	super._ready()


func _ai_chase(delta: float) -> void:
	"""Wolf is more aggressive in chase"""
	if not player or player.is_dead:
		change_state(State.IDLE)
		return

	# Wolves don't give up easily
	if not _is_player_in_range(lose_player_range):
		player_lost.emit()
		player = null
		change_state(State.PATROL)
		return

	# Check if in attack range
	if _is_player_in_range(attack_range) and can_attack:
		change_state(State.ATTACK)
		return

	# Chase with increased speed when close
	var distance_to_player = global_position.distance_to(player.global_position)
	var speed_multiplier = 1.2 if distance_to_player < 200 else 1.0

	var direction = sign(player.global_position.x - global_position.x)
	velocity.x = direction * chase_speed * speed_multiplier
	_update_sprite_direction()


func _perform_attack() -> void:
	"""Wolf lunges at player"""
	# Lunge forward
	var direction = sign(player.global_position.x - global_position.x)
	velocity.x = direction * 400.0  # Lunge speed

	super._perform_attack()
