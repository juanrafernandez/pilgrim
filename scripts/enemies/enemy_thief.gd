extends Enemy
class_name EnemyThief

## Thief/Bandit Enemy
## Chases player, steals item, then flees
## Human hostile enemy

var has_stolen_item: bool = false
var steal_timer: float = 0.0
var steal_duration: float = 5.0  # Flees after 5 seconds
var is_fleeing: bool = false

func _ready() -> void:
	# Thief stats (fast, sneaky)
	max_health = 50
	current_health = max_health
	move_speed = 180.0
	patrol_speed = 120.0
	chase_speed = 250.0  # Very fast
	attack_damage = 15  # 15% damage
	attack_range = 50.0  # Close range to steal
	detection_range = 400.0
	lose_player_range = 700.0
	patrol_distance = 200.0
	patrol_wait_time = 1.5
	attack_cooldown = 2.0

	super._ready()

	# Thief can jump (agile human)
	can_jump = true
	jump_velocity = -500.0  # High jump
	max_jump_distance = 200.0  # Can jump far


func _physics_process(delta: float) -> void:
	# Update steal timer if has stolen
	if has_stolen_item and not is_fleeing:
		steal_timer += delta
		if steal_timer >= steal_duration:
			_start_fleeing()

	super._physics_process(delta)


func _ai_chase(delta: float) -> void:
	"""Chase player to steal, then flee"""
	# If fleeing, run away
	if is_fleeing:
		_ai_flee(delta)
		return

	if not player or player.is_dead:
		change_state(State.IDLE)
		return

	# Check if player is too far (unless already stolen)
	if not has_stolen_item and not _is_player_in_range(lose_player_range):
		player_lost.emit()
		player = null
		change_state(State.PATROL)
		return

	# Check if in steal range
	if _is_player_in_range(attack_range) and can_attack and not has_stolen_item:
		change_state(State.ATTACK)
		return

	# Check for edges
	if _check_edge_ahead():
		if can_jump and _can_jump_gap():
			velocity.y = jump_velocity
			print("%s jumping to chase/flee" % name)

	# Move towards or away from player
	var direction = sign(player.global_position.x - global_position.x)
	if not is_fleeing:
		# Chase player
		velocity.x = direction * chase_speed
	_update_sprite_direction()


func _ai_flee(delta: float) -> void:
	"""Flee with stolen item"""
	# Run away from player
	if player:
		var direction = -sign(player.global_position.x - global_position.x)
		velocity.x = direction * chase_speed * 1.3  # Run even faster when fleeing
		_update_sprite_direction()

	# Check for edges while fleeing
	if _check_edge_ahead():
		if can_jump and _can_jump_gap():
			velocity.y = jump_velocity

	# If far enough, disappear (escaped)
	if player and global_position.distance_to(player.global_position) > 800:
		print("%s escaped with stolen item!" % name)
		_escape()


func _perform_attack() -> void:
	"""Steal item from player"""
	if player and _is_player_in_range(attack_range) and not has_stolen_item:
		# Steal item (TODO: implement inventory system)
		has_stolen_item = true
		steal_timer = 0.0

		# Deal damage during theft
		var knockback = Vector2(sign(player.global_position.x - global_position.x) * 150, -200)
		player.take_damage(attack_damage, knockback, self)

		print("%s stole item from player!" % name)

		attacked.emit(player)


func _start_fleeing() -> void:
	"""Start fleeing after stealing"""
	is_fleeing = true
	chase_speed = chase_speed * 1.2  # Even faster when escaping
	print("%s is fleeing with stolen item!" % name)


func _escape() -> void:
	"""Successfully escaped"""
	# Fade out and remove
	if sprite:
		var tween = create_tween()
		tween.tween_property(sprite, "modulate:a", 0.0, 0.5)
		await tween.finished

	queue_free()


func take_damage(amount: int, knockback_direction: Vector2 = Vector2.ZERO) -> void:
	"""Thief drops item if hit while fleeing"""
	if has_stolen_item and is_fleeing:
		# Drop stolen item
		has_stolen_item = false
		is_fleeing = false
		steal_timer = 0.0
		print("%s dropped stolen item!" % name)
		# TODO: Spawn dropped item

	super.take_damage(amount, knockback_direction)
