extends CharacterBody2D
class_name Player

## Player Controller
## Main player character with state machine, health, and phase progression
## Supports 4 phases: CHILD, ADOLESCENT, KNIGHT, ELDER

# Signals
signal health_changed(new_health: int, max_health: int)
signal died()
signal phase_changed(new_phase: GameManager.PlayerPhase)
signal took_damage(amount: int)
signal landed()

# Movement constants
const SPEED: float = 400.0
const JUMP_VELOCITY: float = -800.0
const ACCELERATION: float = 2000.0
const FRICTION: float = 1500.0

# Combat constants
const ATTACK_DURATION: float = 0.4
const INVINCIBILITY_DURATION: float = 1.0

# State
var current_phase: GameManager.PlayerPhase = GameManager.PlayerPhase.CHILD
var max_health: int = 100
var current_health: int = 100
var is_attacking: bool = false
var is_invincible: bool = false
var is_dead: bool = false

# References
@onready var sprite: ColorRect = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var state_machine: PlayerStateMachine = $StateMachine

# Attack properties
var attack_damage: int = 10
var attack_range: float = 80.0

# Input direction
var input_direction: Vector2 = Vector2.ZERO


func _ready() -> void:
	_setup_phase(current_phase)
	current_health = max_health
	print("Player initialized - Phase: %s" % GameManager.PlayerPhase.keys()[current_phase])


func _physics_process(delta: float) -> void:
	# Get input
	input_direction = _get_input_direction()

	# Let state machine handle movement
	state_machine.physics_update(delta)

	# Move
	move_and_slide()

	# Check if just landed
	if is_on_floor() and velocity.y >= 0:
		if state_machine.previous_state_name == "Fall":
			landed.emit()


func _get_input_direction() -> Vector2:
	"""Get player input direction"""
	var dir = Vector2.ZERO
	dir.x = Input.get_axis("move_left", "move_right")
	return dir


## Take damage
func take_damage(amount: int) -> void:
	if is_invincible or is_dead:
		return

	current_health = maxi(0, current_health - amount)
	health_changed.emit(current_health, max_health)
	took_damage.emit(amount)

	print("Player took %d damage. Health: %d/%d" % [amount, current_health, max_health])

	if current_health <= 0:
		die()
	else:
		_start_invincibility()


## Heal
func heal(amount: int) -> void:
	if is_dead:
		return

	current_health = mini(max_health, current_health + amount)
	health_changed.emit(current_health, max_health)
	print("Player healed %d. Health: %d/%d" % [amount, current_health, max_health])


## Die
func die() -> void:
	if is_dead:
		return

	is_dead = true
	died.emit()
	print("Player died")

	# Notify GameManager
	GameManager.player_died()


## Start invincibility frames
func _start_invincibility() -> void:
	is_invincible = true
	_flash_sprite()

	await get_tree().create_timer(INVINCIBILITY_DURATION).timeout
	is_invincible = false


## Flash sprite during invincibility
func _flash_sprite() -> void:
	var flash_count = 6
	var flash_interval = INVINCIBILITY_DURATION / (flash_count * 2)

	for i in range(flash_count):
		sprite.modulate.a = 0.3
		await get_tree().create_timer(flash_interval).timeout
		sprite.modulate.a = 1.0
		await get_tree().create_timer(flash_interval).timeout


## Attack
func attack() -> void:
	if is_attacking or is_dead:
		return

	is_attacking = true
	_perform_attack()

	await get_tree().create_timer(ATTACK_DURATION).timeout
	is_attacking = false


func _perform_attack() -> void:
	"""Perform attack and check for hits"""
	print("Player attacks!")

	# Get attack area
	var attack_position = global_position + Vector2(attack_range if sprite.scale.x > 0 else -attack_range, 0)

	# Check for enemies in range (will implement when we have enemies)
	# For now, just visual feedback
	_show_attack_effect(attack_position)


func _show_attack_effect(pos: Vector2) -> void:
	"""Show attack visual effect (placeholder)"""
	var effect = ColorRect.new()
	effect.size = Vector2(20, 20)
	effect.position = pos - effect.size / 2
	effect.color = Color(1.0, 0.0, 0.0, 0.7)
	get_parent().add_child(effect)

	await get_tree().create_timer(0.2).timeout
	effect.queue_free()


## Change player phase
func change_phase(new_phase: GameManager.PlayerPhase) -> void:
	if new_phase == current_phase:
		return

	current_phase = new_phase
	_setup_phase(new_phase)
	phase_changed.emit(new_phase)

	print("Player phase changed to: %s" % GameManager.PlayerPhase.keys()[new_phase])


func _setup_phase(phase: GameManager.PlayerPhase) -> void:
	"""Setup player stats and appearance based on phase"""
	match phase:
		GameManager.PlayerPhase.CHILD:
			max_health = 80
			attack_damage = 8
			sprite.color = Color(0.3, 0.8, 0.3)  # Green

		GameManager.PlayerPhase.ADOLESCENT:
			max_health = 100
			attack_damage = 12
			sprite.color = Color(0.2, 0.5, 0.9)  # Blue

		GameManager.PlayerPhase.KNIGHT:
			max_health = 150
			attack_damage = 20
			sprite.color = Color(0.95, 0.95, 0.95)  # White (templar)

		GameManager.PlayerPhase.ELDER:
			max_health = 120
			attack_damage = 15
			sprite.color = Color(0.7, 0.7, 0.7)  # Gray

	# Restore health to new max
	current_health = max_health
	health_changed.emit(current_health, max_health)


## Reset player (for level restart)
func reset() -> void:
	is_dead = false
	is_attacking = false
	is_invincible = false
	current_health = max_health
	velocity = Vector2.ZERO
	health_changed.emit(current_health, max_health)


## Getters
func get_health_percentage() -> float:
	return float(current_health) / float(max_health)


func is_facing_right() -> bool:
	return sprite.scale.x > 0


func set_facing_direction(right: bool) -> void:
	sprite.scale.x = 1.0 if right else -1.0
