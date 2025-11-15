extends Enemy
class_name EnemyMountedKnight

## Mounted Knight Enemy
## Elite enemy on horseback
## Charges at high speed, dismounts when horse falls
## After dismount, fights on foot

var is_mounted: bool = true
var is_charging: bool = false
var charge_distance: float = 0.0
var charge_max_distance: float = 500.0
var is_vulnerable: bool = false  # Vulnerable after charge
var vulnerability_timer: float = 0.0
var vulnerability_duration: float = 2.0

func _ready() -> void:
	# Mounted Knight stats (elite, very dangerous)
	max_health = 120  # Very high HP (includes horse)
	current_health = max_health
	move_speed = 250.0
	patrol_speed = 150.0
	chase_speed = 200.0
	attack_damage = 40  # 40% damage while mounted
	attack_range = 100.0  # Long lance reach
	detection_range = 600.0
	lose_player_range = 900.0
	patrol_distance = 300.0
	patrol_wait_time = 2.0
	attack_cooldown = 3.0  # Slow between charges

	super._ready()

	# Mounted knight can jump (horse can leap)
	can_jump = true
	jump_velocity = -300.0  # Heavy jump
	max_jump_distance = 150.0


func _physics_process(delta: float) -> void:
	# Update vulnerability
	if is_vulnerable:
		vulnerability_timer += delta
		if vulnerability_timer >= vulnerability_duration:
			is_vulnerable = false
			vulnerability_timer = 0.0
			print("%s recovered from vulnerability" % name)

	super._physics_process(delta)


func _ai_attack(delta: float) -> void:
	"""Mounted knight charges"""
	if not is_mounted:
		# Fight on foot like regular knight
		super._ai_attack(delta)
		return

	if not is_charging:
		# Start charge
		is_charging = true
		charge_distance = 0.0
		var direction = sign(player.global_position.x - global_position.x)
		velocity.x = direction * move_speed * 1.5  # Very fast charge
		print("%s begins lance charge!" % name)

	# Check for edges during charge (horse can jump)
	if _check_edge_ahead():
		if can_jump and _can_jump_gap():
			velocity.y = jump_velocity

	# Continue charge
	charge_distance += abs(velocity.x) * delta

	# Check if hit player during charge
	if player and _is_player_in_range(attack_range):
		_perform_attack()
		is_charging = false
		charge_distance = 0.0
		attack_timer = attack_cooldown
		can_attack = false
		_enter_vulnerable_state()
		return

	# Stop charge after max distance
	if charge_distance >= charge_max_distance:
		is_charging = false
		charge_distance = 0.0
		attack_timer = attack_cooldown
		can_attack = false
		_enter_vulnerable_state()
		change_state(State.IDLE)


func _enter_vulnerable_state() -> void:
	"""Enter vulnerable state after charge"""
	is_vulnerable = true
	vulnerability_timer = 0.0
	velocity.x = 0  # Stop moving
	print("%s is vulnerable after charge!" % name)


func _perform_attack() -> void:
	"""Lance charge attack or dismounted sword attack"""
	if is_mounted:
		# Devastating lance charge
		attack_damage = 45  # Even more damage during charge

		if player and _is_player_in_range(attack_range):
			var direction = sign(player.global_position.x - global_position.x)
			var knockback = Vector2(direction * 500, -500)  # Massive knockback
			player.take_damage(attack_damage, knockback, self)
			attacked.emit(player)
			print("%s lance strike!" % name)
	else:
		# Regular sword attack when dismounted
		attack_damage = 25
		super._perform_attack()


func take_damage(amount: int, knockback_direction: Vector2 = Vector2.ZERO) -> void:
	"""Take extra damage when vulnerable, dismount if horse dies"""
	var final_damage = amount

	# Extra damage when vulnerable
	if is_vulnerable:
		final_damage = int(amount * 1.5)
		print("%s takes extra damage while vulnerable!" % name)

	# Check if should dismount (horse falls at 50% HP)
	if is_mounted and current_health - final_damage <= max_health * 0.5:
		_dismount()

	super.take_damage(final_damage, knockback_direction)


func _dismount() -> void:
	"""Dismount from horse and fight on foot"""
	if not is_mounted:
		return

	is_mounted = false
	is_charging = false
	print("%s horse has fallen! Fighting on foot!" % name)

	# Adjust stats for foot combat
	move_speed = 120.0
	chase_speed = 150.0
	attack_damage = 30
	attack_range = 80.0
	patrol_speed = 80.0
	can_jump = true
	jump_velocity = -380.0
	max_jump_distance = 130.0

	# Brief stun when dismounting
	change_state(State.HURT)
	await get_tree().create_timer(1.0).timeout
	if not is_dead:
		change_state(State.CHASE if player else State.PATROL)
