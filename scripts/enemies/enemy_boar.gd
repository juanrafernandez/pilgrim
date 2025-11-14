extends Enemy
class_name EnemyBoar

## Boar Enemy
## Medium aggressive enemy that charges at player
## Tanky with medium damage

var is_charging: bool = false
var charge_distance: float = 0.0
var charge_max_distance: float = 300.0

func _ready() -> void:
	# Boar stats (tanky, charge attack)
	max_health = 60  # High HP
	current_health = max_health
	move_speed = 150.0
	patrol_speed = 100.0
	chase_speed = 180.0
	attack_damage = 12
	attack_range = 80.0
	detection_range = 350.0
	patrol_distance = 180.0
	patrol_wait_time = 2.5
	attack_cooldown = 2.0  # Slower attacks but devastating

	super._ready()


func _ai_attack(delta: float) -> void:
	"""Boar charges at player"""
	if not is_charging:
		# Start charge
		is_charging = true
		charge_distance = 0.0
		var direction = sign(player.global_position.x - global_position.x)
		velocity.x = direction * chase_speed * 1.5  # Charge speed

	# Continue charge
	charge_distance += abs(velocity.x) * delta

	# Check if hit player during charge
	if player and _is_player_in_range(attack_range):
		_perform_attack()
		is_charging = false
		charge_distance = 0.0
		attack_timer = attack_cooldown
		can_attack = false
		change_state(State.CHASE)
		return

	# Stop charge after max distance
	if charge_distance >= charge_max_distance:
		is_charging = false
		charge_distance = 0.0
		attack_timer = attack_cooldown
		can_attack = false
		change_state(State.IDLE)
		# Brief stun after charge
		await get_tree().create_timer(0.5).timeout
		if not is_dead:
			change_state(State.CHASE)


func _perform_attack() -> void:
	"""Boar's charge attack does more damage"""
	if is_charging:
		attack_damage = 18  # Extra damage during charge
	else:
		attack_damage = 12  # Normal damage

	super._perform_attack()
	print("%s charged into player!" % name)
