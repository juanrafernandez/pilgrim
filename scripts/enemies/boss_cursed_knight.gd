extends Enemy
class_name BossCursedKnight

## Cursed Knight Boss
## Final boss - Corrupted Templar with 3 phases
## Phase 1: Physical attacks
## Phase 2: Magic and clones
## Phase 3: Vulnerable to prayer/aura

# Boss phases
enum BossPhase {
	PHASE_1_PHYSICAL,
	PHASE_2_MAGIC,
	PHASE_3_VULNERABLE
}

var current_phase: BossPhase = BossPhase.PHASE_1_PHYSICAL
var phase_1_health_threshold: float = 0.66  # 66% HP
var phase_2_health_threshold: float = 0.33  # 33% HP

# Phase 2 abilities
var can_teleport: bool = false
var teleport_cooldown: float = 5.0
var teleport_timer: float = 0.0
var clone_count: int = 0
var max_clones: int = 2

# Phase 3
var is_vulnerable_to_prayer: bool = false
var prayer_damage_multiplier: float = 3.0

# Attack patterns
var combo_count: int = 0
var max_combo: int = 3

func _ready() -> void:
	# Boss stats (extremely powerful)
	max_health = 300  # Boss HP
	current_health = max_health
	move_speed = 150.0
	patrol_speed = 100.0
	chase_speed = 200.0
	attack_damage = 45  # REBALANCED: 45 dmg (was 40) - boss is harder, shields are stronger now
	attack_range = 100.0
	detection_range = 800.0  # Always aware
	lose_player_range = 9999.0  # Never loses player
	patrol_distance = 200.0
	patrol_wait_time = 1.0
	attack_cooldown = 1.0  # Fast attacks

	super._ready()

	# Boss can jump
	can_jump = true
	jump_velocity = -450.0
	max_jump_distance = 200.0

	print("=== BOSS BATTLE: CURSED KNIGHT ===")


func _physics_process(delta: float) -> void:
	# Update teleport cooldown (Phase 2)
	if current_phase == BossPhase.PHASE_2_MAGIC:
		teleport_timer += delta

	super._physics_process(delta)


func _ai_chase(delta: float) -> void:
	"""Boss chase behavior with phase-specific actions"""
	if not player or player.is_dead:
		change_state(State.IDLE)
		return

	# Phase-specific behavior
	match current_phase:
		BossPhase.PHASE_1_PHYSICAL:
			_phase_1_chase(delta)
		BossPhase.PHASE_2_MAGIC:
			_phase_2_chase(delta)
		BossPhase.PHASE_3_VULNERABLE:
			_phase_3_chase(delta)

	# Check if in attack range
	if _is_player_in_range(attack_range) and can_attack:
		change_state(State.ATTACK)
		return

	# Standard movement
	if _check_edge_ahead():
		if can_jump and _can_jump_gap():
			velocity.y = jump_velocity

	var direction = sign(player.global_position.x - global_position.x)
	velocity.x = direction * chase_speed
	_update_sprite_direction()


func _phase_1_chase(delta: float) -> void:
	"""Phase 1: Aggressive physical pursuit"""
	chase_speed = 200.0
	attack_damage = 45  # REBALANCED: 45 dmg (was 40)


func _phase_2_chase(delta: float) -> void:
	"""Phase 2: Teleport and magic"""
	chase_speed = 180.0
	attack_damage = 55  # REBALANCED: 55 dmg (was 50) - more dangerous

	# Teleport ability
	if teleport_timer >= teleport_cooldown:
		_teleport_to_player()
		teleport_timer = 0.0


func _phase_3_chase(delta: float) -> void:
	"""Phase 3: Vulnerable but desperate"""
	chase_speed = 220.0  # Faster, desperate
	attack_damage = 65  # REBALANCED: 65 dmg (was 60) - maximum damage


func _perform_attack() -> void:
	"""Boss attack with combo system"""
	match current_phase:
		BossPhase.PHASE_1_PHYSICAL:
			_attack_phase_1()
		BossPhase.PHASE_2_MAGIC:
			_attack_phase_2()
		BossPhase.PHASE_3_VULNERABLE:
			_attack_phase_3()

	combo_count += 1
	if combo_count >= max_combo:
		combo_count = 0


func _attack_phase_1() -> void:
	"""Phase 1: Heavy sword combos"""
	# Powerful sword slash
	var direction = sign(player.global_position.x - global_position.x)
	velocity.x = direction * 200.0  # Lunge

	if player and _is_player_in_range(attack_range):
		var knockback = Vector2(direction * 400, -400)
		player.take_damage(attack_damage, knockback, self)
		attacked.emit(player)
		print("BOSS: Heavy slash! [%d/%d combo]" % [combo_count + 1, max_combo])


func _attack_phase_2() -> void:
	"""Phase 2: Magic dark wave attack"""
	# Dark magic attack (AOE)
	print("BOSS: Dark magic attack!")

	if player and _is_player_in_range(attack_range * 1.5):  # Longer range
		var direction = sign(player.global_position.x - global_position.x)
		var knockback = Vector2(direction * 350, -350)
		player.take_damage(attack_damage, knockback, self)
		attacked.emit(player)

	# Chance to summon clone
	if clone_count < max_clones and randf() < 0.3:
		_summon_clone()


func _attack_phase_3() -> void:
	"""Phase 3: Desperate all-out attacks"""
	# Multi-hit combo
	var direction = sign(player.global_position.x - global_position.x)

	if player and _is_player_in_range(attack_range):
		var knockback = Vector2(direction * 500, -500)
		player.take_damage(attack_damage, knockback, self)
		attacked.emit(player)
		print("BOSS: Desperate strike!")


func _teleport_to_player() -> void:
	"""Teleport near player (Phase 2)"""
	if not player:
		return

	# Teleport to side of player
	var offset = Vector2(150 * (1 if randf() < 0.5 else -1), 0)
	global_position = player.global_position + offset

	print("BOSS: Teleported!")


func _summon_clone() -> void:
	"""Summon shadow clone (Phase 2)"""
	# TODO: Instantiate clone enemy
	clone_count += 1
	print("BOSS: Summoned shadow clone! [%d/%d]" % [clone_count, max_clones])


func take_damage(amount: int, knockback_direction: Vector2 = Vector2.ZERO) -> void:
	"""Boss takes damage and changes phases"""
	var final_damage = amount

	# Phase 3: Vulnerable to prayer/holy attacks
	if current_phase == BossPhase.PHASE_3_VULNERABLE:
		# TODO: Check if attack is prayer/holy type
		final_damage = int(amount * prayer_damage_multiplier)
		print("BOSS: Vulnerable! Taking %dx damage!" % prayer_damage_multiplier)

	# Reduced knockback for boss
	knockback_direction = knockback_direction * 0.3

	super.take_damage(final_damage, knockback_direction)

	# Check for phase transitions
	_check_phase_transition()


func _check_phase_transition() -> void:
	"""Check if boss should change phase"""
	var health_percent = float(current_health) / float(max_health)

	if current_phase == BossPhase.PHASE_1_PHYSICAL and health_percent <= phase_1_health_threshold:
		_transition_to_phase_2()
	elif current_phase == BossPhase.PHASE_2_MAGIC and health_percent <= phase_2_health_threshold:
		_transition_to_phase_3()


func _transition_to_phase_2() -> void:
	"""Transition to Phase 2: Magic and Clones"""
	current_phase = BossPhase.PHASE_2_MAGIC
	can_teleport = true
	print("\n=== PHASE 2: DARK MAGIC UNLEASHED ===")
	print("Boss can now teleport and summon clones!\n")

	# Brief invulnerability during transition
	change_state(State.IDLE)
	await get_tree().create_timer(2.0).timeout
	if not is_dead:
		change_state(State.CHASE if player else State.PATROL)


func _transition_to_phase_3() -> void:
	"""Transition to Phase 3: Vulnerable to Prayer"""
	current_phase = BossPhase.PHASE_3_VULNERABLE
	is_vulnerable_to_prayer = true
	print("\n=== PHASE 3: CORRUPTION WEAKENING ===")
	print("Boss is vulnerable to holy prayer/aura!\n")

	# Brief stun during transition
	change_state(State.IDLE)
	await get_tree().create_timer(2.0).timeout
	if not is_dead:
		change_state(State.CHASE if player else State.PATROL)


func die() -> void:
	"""Boss death sequence"""
	print("\n=== CURSED KNIGHT DEFEATED ===")
	print("The corruption has been purified!")

	super.die()
