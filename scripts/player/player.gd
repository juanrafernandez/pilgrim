extends CharacterBody2D
class_name Player

# Player controller for Camino Maldito
# Handles movement, jumping, combat, and player state management

# Signals
signal health_changed(new_health: int, max_health: int)
signal died()
signal virtue_action_performed(virtue_type: String, amount: int)
signal landed()
signal jumped()
signal attacked()

# Enums
enum State {
	IDLE,
	RUNNING,
	JUMPING,
	FALLING,
	ATTACKING,
	TAKING_DAMAGE,
	DEAD
}

enum PlayerPhase {
	CHILD,      # Levels 1-8
	ADOLESCENT, # Levels 9-16
	KNIGHT,     # Levels 17-24
	ELDER       # Levels 25-32
}

# Constants - Movement
const WALK_SPEED: float = 200.0
const RUN_SPEED: float = 300.0
const JUMP_VELOCITY: float = -450.0
const WALL_JUMP_VELOCITY: Vector2 = Vector2(300.0, -400.0)
const ACCELERATION: float = 1500.0
const FRICTION: float = 1200.0
const AIR_RESISTANCE: float = 200.0

# Constants - Combat
const ATTACK_DURATION: float = 0.3
const DAMAGE_INVINCIBILITY_TIME: float = 1.0
const KNOCKBACK_FORCE: float = 300.0

# Exported variables - Configuration
@export_group("Movement")
@export var max_speed: float = 300.0
@export var jump_height: float = 450.0
@export var gravity_multiplier: float = 1.0
@export var coyote_time: float = 0.15  # Time player can jump after leaving platform
@export var jump_buffer_time: float = 0.1  # Time to buffer jump input before landing

@export_group("Combat")
@export var max_health: int = 100
@export var base_attack_damage: int = 10
@export var attack_range: float = 40.0

@export_group("Player Phase")
@export var current_phase: PlayerPhase = PlayerPhase.CHILD

# Public variables
var current_health: int
var can_double_jump: bool = false  # Unlocked in adolescent phase
var can_dash: bool = false  # Unlocked in knight phase
var current_state: State = State.IDLE

# Private variables
var _is_attacking: bool = false
var _attack_timer: float = 0.0
var _is_invincible: bool = false
var _invincibility_timer: float = 0.0
var _coyote_timer: float = 0.0
var _jump_buffer_timer: float = 0.0
var _has_double_jumped: bool = false
var _facing_right: bool = true
var _gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

# Node references
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var attack_area: Area2D = $AttackArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer if has_node("AnimationPlayer") else null


func _ready() -> void:
	current_health = max_health
	_setup_collision_layers()
	_update_phase_abilities()

	# Connect to GameManager
	if GameManager:
		GameManager.state_changed.connect(_on_game_state_changed)

	# Emit initial health
	health_changed.emit(current_health, max_health)


func _setup_collision_layers() -> void:
	# Layer 1: Player
	collision_layer = 1
	# Collide with: Ground (2), Enemies (4), Hazards (8), Collectibles (16)
	collision_mask = 2 + 4 + 8 + 16


func _update_phase_abilities() -> void:
	"""Update abilities based on player's current life phase"""
	match current_phase:
		PlayerPhase.CHILD:
			can_double_jump = false
			can_dash = false
			max_speed = 250.0
		PlayerPhase.ADOLESCENT:
			can_double_jump = true
			can_dash = false
			max_speed = 300.0
		PlayerPhase.KNIGHT:
			can_double_jump = true
			can_dash = true
			max_speed = 350.0
		PlayerPhase.ELDER:
			can_double_jump = true
			can_dash = true
			max_speed = 280.0  # Slower but wiser


func _physics_process(delta: float) -> void:
	if current_state == State.DEAD:
		return

	# Update timers
	_update_timers(delta)

	# Apply gravity
	if not is_on_floor():
		velocity.y += _gravity * gravity_multiplier * delta

	# Handle input and movement
	_handle_input(delta)
	_handle_movement(delta)

	# Update state
	_update_state()

	# Move character
	var was_on_floor = is_on_floor()
	move_and_slide()

	# Check if just landed
	if not was_on_floor and is_on_floor():
		_on_landed()


func _update_timers(delta: float) -> void:
	"""Update all internal timers"""
	# Attack timer
	if _attack_timer > 0:
		_attack_timer -= delta
		if _attack_timer <= 0:
			_is_attacking = false

	# Invincibility timer
	if _invincibility_timer > 0:
		_invincibility_timer -= delta
		if _invincibility_timer <= 0:
			_is_invincible = false

	# Coyote time (grace period for jumping after leaving platform)
	if is_on_floor():
		_coyote_timer = coyote_time
	elif _coyote_timer > 0:
		_coyote_timer -= delta

	# Jump buffer (remember jump input for a short time)
	if _jump_buffer_timer > 0:
		_jump_buffer_timer -= delta


func _handle_input(delta: float) -> void:
	"""Process player input"""
	if _is_attacking:
		return  # Can't move while attacking

	# Jump input
	if Input.is_action_just_pressed("jump"):
		_jump_buffer_timer = jump_buffer_time

	# Try to jump
	if _jump_buffer_timer > 0:
		if is_on_floor() or _coyote_timer > 0:
			_perform_jump()
			_jump_buffer_timer = 0
		elif can_double_jump and not _has_double_jumped and not is_on_floor():
			_perform_double_jump()
			_jump_buffer_timer = 0

	# Attack input
	if Input.is_action_just_pressed("attack") and not _is_attacking:
		_perform_attack()


func _handle_movement(delta: float) -> void:
	"""Handle horizontal movement"""
	if _is_attacking:
		# Reduce speed while attacking
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		return

	# Get input direction
	var input_direction = Input.get_axis("move_left", "move_right")

	if input_direction != 0:
		# Accelerate
		velocity.x = move_toward(velocity.x, input_direction * max_speed, ACCELERATION * delta)

		# Update facing direction
		if input_direction > 0 and not _facing_right:
			_flip_sprite(true)
		elif input_direction < 0 and _facing_right:
			_flip_sprite(false)
	else:
		# Apply friction
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, AIR_RESISTANCE * delta)


func _update_state() -> void:
	"""Update current state based on conditions"""
	if _is_attacking:
		current_state = State.ATTACKING
	elif not is_on_floor():
		if velocity.y < 0:
			current_state = State.JUMPING
		else:
			current_state = State.FALLING
	elif abs(velocity.x) > 10:
		current_state = State.RUNNING
	else:
		current_state = State.IDLE


func _perform_jump() -> void:
	"""Execute a jump"""
	velocity.y = -jump_height
	_coyote_timer = 0
	_has_double_jumped = false
	jumped.emit()


func _perform_double_jump() -> void:
	"""Execute a double jump (adolescent+ only)"""
	velocity.y = -jump_height * 0.8  # Slightly weaker than regular jump
	_has_double_jumped = true
	jumped.emit()


func _perform_attack() -> void:
	"""Execute an attack"""
	_is_attacking = true
	_attack_timer = ATTACK_DURATION
	attacked.emit()

	# Check for enemies in attack range
	_check_attack_hits()


func _check_attack_hits() -> void:
	"""Check if attack hits any enemies"""
	if not attack_area:
		return

	var enemies = attack_area.get_overlapping_bodies()
	for enemy in enemies:
		if enemy.has_method("take_damage"):
			var damage = base_attack_damage
			# Apply phase-based damage modifiers
			match current_phase:
				PlayerPhase.KNIGHT:
					damage = int(damage * 1.5)  # Knights are stronger
				PlayerPhase.ELDER:
					damage = int(damage * 1.3)  # Wisdom compensates for age

			enemy.take_damage(damage, global_position)


func _flip_sprite(face_right: bool) -> void:
	"""Flip sprite to face the correct direction"""
	_facing_right = face_right
	if sprite:
		sprite.flip_h = not face_right

	# Flip attack area
	if attack_area:
		attack_area.scale.x = 1 if face_right else -1


func _on_landed() -> void:
	"""Called when player lands on ground"""
	_has_double_jumped = false
	landed.emit()


# Public Methods

func take_damage(damage: int, source_position: Vector2 = Vector2.ZERO) -> void:
	"""Take damage from an enemy or hazard"""
	if _is_invincible or current_state == State.DEAD:
		return

	current_health -= damage
	current_health = max(0, current_health)
	health_changed.emit(current_health, max_health)

	# Apply knockback
	if source_position != Vector2.ZERO:
		var knockback_direction = (global_position - source_position).normalized()
		velocity = knockback_direction * KNOCKBACK_FORCE

	# Become invincible briefly
	_is_invincible = true
	_invincibility_timer = DAMAGE_INVINCIBILITY_TIME

	# Update GameManager
	if GameManager:
		GameManager.player_health = current_health

	# Check if dead
	if current_health <= 0:
		_die()


func heal(amount: int) -> void:
	"""Heal the player"""
	current_health = min(current_health + amount, max_health)
	health_changed.emit(current_health, max_health)

	if GameManager:
		GameManager.player_health = current_health


func add_virtue(amount: int) -> void:
	"""Add virtue points (good actions)"""
	if GameManager:
		GameManager.add_virtue(amount)
	virtue_action_performed.emit("add", amount)


func remove_virtue(amount: int) -> void:
	"""Remove virtue points (bad actions)"""
	if GameManager:
		GameManager.remove_virtue(amount)
	virtue_action_performed.emit("remove", amount)


func set_phase(phase: PlayerPhase) -> void:
	"""Set the player's current life phase"""
	current_phase = phase
	_update_phase_abilities()


func reset() -> void:
	"""Reset player to initial state"""
	current_health = max_health
	velocity = Vector2.ZERO
	current_state = State.IDLE
	_is_attacking = false
	_is_invincible = false
	_has_double_jumped = false
	health_changed.emit(current_health, max_health)


func _die() -> void:
	"""Handle player death"""
	current_state = State.DEAD
	velocity = Vector2.ZERO
	died.emit()

	# Notify GameManager
	if GameManager:
		GameManager.player_died()


func _on_game_state_changed(new_state: GameManager.GameState) -> void:
	"""React to game state changes"""
	match new_state:
		GameManager.GameState.PAUSED:
			set_physics_process(false)
		GameManager.GameState.PLAYING:
			set_physics_process(true)
		GameManager.GameState.LEVEL_TRANSITION:
			set_physics_process(false)


# Debug methods
func get_state_name() -> String:
	"""Get current state as string for debugging"""
	match current_state:
		State.IDLE: return "IDLE"
		State.RUNNING: return "RUNNING"
		State.JUMPING: return "JUMPING"
		State.FALLING: return "FALLING"
		State.ATTACKING: return "ATTACKING"
		State.TAKING_DAMAGE: return "TAKING_DAMAGE"
		State.DEAD: return "DEAD"
		_: return "UNKNOWN"
