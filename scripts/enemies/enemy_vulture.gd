extends CharacterBody2D
class_name EnemyVulture

## Vulture Enemy
## Flying enemy that circles overhead
## Only attacks when player has <50% health
## Etapa: Adolescencia - Adultez

# Signals
signal health_changed(new_health: int, max_health: int)
signal died()
signal player_detected(player: Player)

# Stats
var max_health: int = 20  # Fragile
var current_health: int = 20
var fly_speed: float = 120.0
var dive_speed: float = 300.0
var attack_damage: int = 8  # REBALANCED: 8 dmg (was 10) - balanced for early game
var detection_range: float = 500.0
var is_dead: bool = false

# Flying behavior
var circle_radius: float = 200.0
var circle_angle: float = 0.0
var circle_speed: float = 1.5  # Radians per second
var circle_center: Vector2
var is_diving: bool = false
var dive_start_position: Vector2

# References
var player: Player = null
@onready var sprite: ColorRect = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var detection_area: Area2D = $DetectionArea


func _ready() -> void:
	current_health = max_health
	circle_center = global_position
	circle_angle = randf() * TAU  # Random starting angle

	# Setup detection
	if detection_area:
		detection_area.body_entered.connect(_on_body_entered_detection)
		detection_area.body_exited.connect(_on_body_exited_detection)

	print("%s spawned (flying enemy)" % name)


func _physics_process(delta: float) -> void:
	if is_dead:
		return

	if is_diving:
		_ai_dive(delta)
	else:
		_ai_circle(delta)

	move_and_slide()


func _ai_circle(delta: float) -> void:
	"""Circle in the air, watching for weak prey"""
	# Increment angle for circular motion
	circle_angle += circle_speed * delta
	if circle_angle > TAU:
		circle_angle -= TAU

	# Calculate position on circle
	var target_position = circle_center + Vector2(
		cos(circle_angle) * circle_radius,
		sin(circle_angle) * circle_radius
	)

	# Move towards target position
	var direction = (target_position - global_position).normalized()
	velocity = direction * fly_speed

	# Update sprite direction
	if velocity.x != 0:
		sprite.scale.x = -1.0 if velocity.x < 0 else 1.0

	# Check if should attack
	if player and not player.is_dead:
		var player_health_percent = float(player.current_health) / float(player.max_health)

		# Only attack if player is below 50% health
		if player_health_percent < 0.5 and global_position.distance_to(player.global_position) < detection_range:
			_start_dive()


func _ai_dive(delta: float) -> void:
	"""Dive attack towards player"""
	if not player or player.is_dead:
		is_diving = false
		return

	# Dive towards player
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * dive_speed

	# Check if close to player (attack)
	if global_position.distance_to(player.global_position) < 50:
		_perform_attack()
		_end_dive()


func _start_dive() -> void:
	"""Start diving attack"""
	is_diving = true
	dive_start_position = global_position
	print("%s diving to attack weakened player!" % name)


func _end_dive() -> void:
	"""End dive and return to circling"""
	is_diving = false

	# Return to circling at higher altitude
	circle_center = global_position + Vector2(0, -150)

	# Brief cooldown before next dive
	await get_tree().create_timer(3.0).timeout


func _perform_attack() -> void:
	"""Peck attack while diving"""
	if player and global_position.distance_to(player.global_position) < 60:
		var knockback = Vector2(sign(player.global_position.x - global_position.x) * 200, -300)
		player.take_damage(attack_damage, knockback, self)
		print("%s pecked player!" % name)


func take_damage(amount: int, knockback_direction: Vector2 = Vector2.ZERO) -> void:
	"""Vulture takes damage"""
	if is_dead:
		return

	current_health = maxi(0, current_health - amount)
	health_changed.emit(current_health, max_health)
	print("%s took %d damage. Health: %d/%d" % [name, amount, current_health, max_health])

	# Vultures are fragile - knocked back easily
	if knockback_direction != Vector2.ZERO:
		velocity = knockback_direction * 400.0

	if current_health <= 0:
		die()


func die() -> void:
	"""Vulture dies and falls"""
	if is_dead:
		return

	is_dead = true
	died.emit()
	print("%s died" % name)

	# Fall to ground
	var tween = create_tween()
	tween.tween_property(self, "velocity:y", 500.0, 0.5)
	tween.tween_property(sprite, "modulate:a", 0.0, 1.0)
	await tween.finished

	queue_free()


func _on_body_entered_detection(body: Node2D) -> void:
	"""Detect player"""
	if body is Player and not body.is_dead:
		player = body
		player_detected.emit(player)
		print("%s spotted player" % name)


func _on_body_exited_detection(body: Node2D) -> void:
	"""Lose sight of player"""
	if body is Player:
		# Keep tracking for a bit
		pass
