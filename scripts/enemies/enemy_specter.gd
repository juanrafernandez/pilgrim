extends CharacterBody2D
class_name EnemySpecter

## Specter/Ghost Enemy
## Spiritual enemy that floats and phases through objects
## Vulnerable only to aura/holy attacks
## Appears at night or in cursed areas

# Signals
signal health_changed(new_health: int, max_health: int)
signal died()
signal player_detected(player: Player)

# Stats
var max_health: int = 60
var current_health: int = 60
var float_speed: float = 100.0
var chase_speed: float = 150.0
var attack_damage: int = 25  # 25% damage - drains life force
var detection_range: float = 500.0
var attack_range: float = 70.0
var is_dead: bool = false

# Floating behavior
var float_amplitude: float = 30.0  # How much to bob up/down
var float_frequency: float = 2.0  # How fast to bob
var float_time: float = 0.0
var base_y: float = 0.0

# Phasing
var is_phasing: bool = false
var phase_duration: float = 2.0
var phase_cooldown: float = 5.0
var phase_timer: float = 0.0

# State
enum SpecterState {
	WANDERING,
	CHASING,
	ATTACKING
}
var current_state: SpecterState = SpecterState.WANDERING

# References
var player: Player = null
@onready var sprite: ColorRect = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var detection_area: Area2D = $DetectionArea


func _ready() -> void:
	current_health = max_health
	base_y = global_position.y
	float_time = randf() * TAU

	# Specters can phase through walls (collision layer/mask)
	collision_layer = 4  # Enemy layer
	collision_mask = 1   # Only collide with player

	# Setup detection
	if detection_area:
		detection_area.body_entered.connect(_on_body_entered_detection)

	# Semi-transparent
	if sprite:
		sprite.modulate.a = 0.7

	print("%s spawned (spiritual enemy)" % name)


func _physics_process(delta: float) -> void:
	if is_dead:
		return

	# Update float animation
	float_time += delta * float_frequency
	var float_offset = sin(float_time) * float_amplitude

	# Update phase timer
	if is_phasing:
		phase_timer += delta
		if phase_timer >= phase_duration:
			_end_phase()

	# AI behavior
	match current_state:
		SpecterState.WANDERING:
			_ai_wander(delta, float_offset)
		SpecterState.CHASING:
			_ai_chase(delta, float_offset)
		SpecterState.ATTACKING:
			_ai_attack(delta, float_offset)

	move_and_slide()


func _ai_wander(delta: float, float_offset: float) -> void:
	"""Wander aimlessly while floating"""
	# Slow drifting movement
	velocity.x = move_toward(velocity.x, 0, float_speed * delta)

	# Apply float offset
	global_position.y = base_y + float_offset

	# Check for player
	if player and global_position.distance_to(player.global_position) < detection_range:
		current_state = SpecterState.CHASING
		print("%s detected player's life force!" % name)


func _ai_chase(delta: float, float_offset: float) -> void:
	"""Chase player while phasing through walls"""
	if not player or player.is_dead:
		current_state = SpecterState.WANDERING
		player = null
		return

	# Check if in attack range
	var distance = global_position.distance_to(player.global_position)
	if distance < attack_range:
		current_state = SpecterState.ATTACKING
		return

	# Move towards player (can phase through walls)
	var direction = (player.global_position - global_position).normalized()
	velocity.x = direction.x * chase_speed

	# Float towards player's Y position
	base_y = move_toward(base_y, player.global_position.y, float_speed * delta)
	global_position.y = base_y + float_offset

	# Update sprite direction
	if velocity.x != 0:
		sprite.scale.x = -1.0 if velocity.x < 0 else 1.0

	# Activate phasing if moving through walls
	if not is_phasing and phase_timer <= 0:
		_start_phase()


func _ai_attack(delta: float, float_offset: float) -> void:
	"""Attack player - drain life force"""
	if not player or player.is_dead:
		current_state = SpecterState.WANDERING
		return

	# Stop moving
	velocity.x = 0

	# Perform attack
	_perform_attack()

	# Return to chasing
	await get_tree().create_timer(1.5).timeout
	if not is_dead:
		current_state = SpecterState.CHASING


func _start_phase() -> void:
	"""Begin phasing through objects"""
	is_phasing = true
	phase_timer = 0.0

	# Make more transparent
	if sprite:
		sprite.modulate.a = 0.4

	# Disable collision with terrain
	collision_mask = 1  # Only player

	print("%s is phasing!" % name)


func _end_phase() -> void:
	"""End phasing"""
	is_phasing = false
	phase_timer = -phase_cooldown  # Cooldown before next phase

	# Restore opacity
	if sprite:
		sprite.modulate.a = 0.7

	print("%s stopped phasing" % name)


func _perform_attack() -> void:
	"""Drain player's life force"""
	if player and global_position.distance_to(player.global_position) < attack_range:
		# No knockback - ghostly touch
		player.take_damage(attack_damage, Vector2.ZERO)
		print("%s drained life force!" % name)


func take_damage(amount: int, knockback_direction: Vector2 = Vector2.ZERO) -> void:
	"""Specter only takes damage from holy/aura attacks"""
	# TODO: Check if attack is holy/aura type
	# For now, all attacks work but with reduced damage
	var final_damage = int(amount * 0.7)  # 30% damage reduction

	if is_dead:
		return

	current_health = maxi(0, current_health - final_damage)
	health_changed.emit(current_health, max_health)
	print("%s took %d damage (spiritual). Health: %d/%d" % [name, final_damage, current_health, max_health])

	# No knockback for spirits
	if current_health <= 0:
		die()


func die() -> void:
	"""Specter disperses"""
	if is_dead:
		return

	is_dead = true
	died.emit()
	print("%s dispersed" % name)

	# Fade out
	if sprite:
		var tween = create_tween()
		tween.tween_property(sprite, "modulate:a", 0.0, 1.0)
		await tween.finished

	queue_free()


func _on_body_entered_detection(body: Node2D) -> void:
	"""Detect player"""
	if body is Player and not body.is_dead:
		player = body
		player_detected.emit(player)
		current_state = SpecterState.CHASING
