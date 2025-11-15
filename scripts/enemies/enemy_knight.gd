extends Enemy
class_name EnemyKnight

## Knight on Foot Enemy
## Fallen Templar - slow but powerful
## Alternates between attack and guard stance

enum KnightState {
	ATTACKING,
	GUARDING
}

var knight_state: KnightState = KnightState.ATTACKING
var guard_active: bool = false
var guard_damage_reduction: float = 0.5  # Takes 50% less damage while guarding
var state_switch_timer: float = 0.0
var state_switch_interval: float = 3.0  # Switch every 3 seconds

func _ready() -> void:
	# Knight stats (tanky, slow, powerful)
	max_health = 100  # Very high HP
	current_health = max_health
	move_speed = 100.0
	patrol_speed = 60.0  # Slow patrol
	chase_speed = 120.0  # Methodical pursuit
	attack_damage = 28  # REBALANCED: 28 dmg (was 30) - balanced for mid-late game
	attack_range = 90.0  # Long reach with sword
	detection_range = 450.0
	lose_player_range = 700.0
	patrol_distance = 150.0
	patrol_wait_time = 3.0
	attack_cooldown = 2.5  # Slow but powerful attacks

	super._ready()

	# Knight can jump (armored but capable)
	can_jump = true
	jump_velocity = -350.0  # Heavy jump
	max_jump_distance = 120.0  # Limited jump distance


func _physics_process(delta: float) -> void:
	# Update stance switching
	state_switch_timer += delta
	if state_switch_timer >= state_switch_interval:
		_switch_stance()
		state_switch_timer = 0.0

	super._physics_process(delta)


func _switch_stance() -> void:
	"""Switch between attacking and guarding"""
	if knight_state == KnightState.ATTACKING:
		knight_state = KnightState.GUARDING
		guard_active = true
		print("%s raised guard!" % name)
	else:
		knight_state = KnightState.ATTACKING
		guard_active = false
		print("%s lowered guard to attack!" % name)


func _ai_chase(delta: float) -> void:
	"""Knight chases methodically (UPDATED for decoupled base class)"""
	# Check if target is still valid
	if not target or (target.has_method("is_dead") and target.is_dead):
		change_state(State.IDLE)
		return

	# Check if target is too far
	if not _is_target_in_range(lose_player_range):
		target_lost.emit()
		target = null
		change_state(State.PATROL)
		return

	# Check if in attack range and not guarding
	if _is_target_in_range(attack_range) and can_attack and knight_state == KnightState.ATTACKING:
		change_state(State.ATTACK)
		return

	# Check for edges
	if _check_edge_ahead():
		if can_jump and _can_jump_gap():
			velocity.y = jump_velocity

	# Move towards target (slower when guarding)
	var direction = sign(target.global_position.x - global_position.x)
	var speed = chase_speed if knight_state == KnightState.ATTACKING else chase_speed * 0.5
	velocity.x = direction * speed
	_update_sprite_direction()


func _perform_attack() -> void:
	"""Knight's powerful sword slash (UPDATED for decoupled base class)"""
	# Can only attack when not guarding
	if knight_state == KnightState.GUARDING:
		return

	# Heavy sword swing with knockback
	if target:
		var direction = sign(target.global_position.x - global_position.x)
		velocity.x = direction * 150.0  # Small lunge forward

	super._perform_attack()
	print("%s slashed with sword!" % name)


func take_damage(amount: int, knockback_direction: Vector2 = Vector2.ZERO) -> void:
	"""Knight takes reduced damage while guarding"""
	var final_damage = amount

	if guard_active:
		final_damage = int(amount * guard_damage_reduction)
		print("%s blocked! Damage reduced from %d to %d" % [name, amount, final_damage])

		# No knockback while guarding
		knockback_direction = Vector2.ZERO

	super.take_damage(final_damage, knockback_direction)
