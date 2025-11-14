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
var attack_range: float = 60.0
var detection_range: float = 400.0
var lose_player_range: float = 600.0

# State
var current_state: State = State.IDLE
var is_dead: bool = false
var facing_right: bool = true

# AI behavior
var patrol_distance: float = 200.0
var patrol_wait_time: float = 2.0
var attack_cooldown: float = 1.5
var can_attack: bool = true

# References
var player: Player = null
var spawn_position: Vector2
var patrol_target: Vector2
var patrol_timer: float = 0.0
var attack_timer: float = 0.0

# Nodes (to be set by child classes or scene)
@onready var sprite: ColorRect = $Sprite if has_node("Sprite") else null
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var detection_area: Area2D = $DetectionArea if has_node("DetectionArea") else null


func _ready() -> void:
	spawn_position = global_position
	current_health = max_health
	_setup_detection_area()
	print("%s spawned at %s" % [name, spawn_position])


func _physics_process(delta: float) -> void:
	if is_dead:
		return

	# Update timers
	if patrol_timer > 0:
		patrol_timer -= delta
	if attack_timer > 0:
		attack_timer -= delta
		can_attack = attack_timer <= 0

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

	# Move towards player
	var direction = sign(player.global_position.x - global_position.x)
	velocity.x = direction * chase_speed
	_update_sprite_direction()


func _ai_attack(delta: float) -> void:
	"""Attack behavior"""
	velocity.x = move_toward(velocity.x, 0, move_speed * delta * 10)

	if not player or player.is_dead:
		change_state(State.IDLE)
		return

	# Perform attack
	_perform_attack()

	# Return to chase after attack
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


func _perform_attack() -> void:
	"""Perform attack on player"""
	if player and _is_player_in_range(attack_range):
		player.take_damage(attack_damage)
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

	# Fade out and remove
	_death_animation()


func _death_animation() -> void:
	"""Play death animation and remove enemy"""
	if sprite:
		var tween = create_tween()
		tween.tween_property(sprite, "modulate:a", 0.0, 1.0)
		await tween.finished

	queue_free()


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
