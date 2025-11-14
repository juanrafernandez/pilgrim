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
	detection_range = 300.0
	patrol_distance = 150.0
	patrol_wait_time = 3.0

	super._ready()


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
