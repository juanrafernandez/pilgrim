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
signal weapon_changed(new_weapon: Weapon)
signal weapon_durability_changed(current: int, max: int)
signal projectile_thrown(projectile: Projectile)

# Enums
enum WeaponType {
	DAGGER,    # Fast, straight projectile
	LANCE,     # Slower, more damage
	AXE,       # Arc trajectory
	TORCH      # Fire projectile with area damage
}

# Movement constants
const SPEED: float = 400.0
const JUMP_VELOCITY: float = -800.0
const ACCELERATION: float = 2000.0
const FRICTION: float = 1500.0

# Combat constants
const ATTACK_DURATION: float = 0.4
const INVINCIBILITY_DURATION: float = 1.0
const PROJECTILE_COOLDOWN: float = 0.5

# Projectile scenes
const PROJECTILE_DAGGER = preload("res://scenes/projectiles/projectile_dagger.tscn")

# State
var current_phase: GameManager.PlayerPhase = GameManager.PlayerPhase.CHILD
var max_health: int = 100
var current_health: int = 100
var is_attacking: bool = false
var is_invincible: bool = false
var is_dead: bool = false

# Weapon state
var current_weapon_type: WeaponType = WeaponType.DAGGER  # For projectiles
var equipped_weapon: Weapon = null  # Current melee weapon (NEW SYSTEM)
var can_throw_projectile: bool = true
var projectile_cooldown_timer: float = 0.0

# References
@onready var sprite: ColorRect = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var state_machine: PlayerStateMachine = $StateMachine

# Camera reference (for boundary checking and screenshake)
var camera_controller: CameraController = null

# Attack properties
var attack_damage: int = 10
var attack_range: float = 80.0

# Input direction
var input_direction: Vector2 = Vector2.ZERO

# Checkpoint system (auto-save last safe ground position)
var last_safe_position: Vector2 = Vector2.ZERO
var checkpoint_cooldown: float = 0.0
const CHECKPOINT_INTERVAL: float = 0.5  # Update checkpoint every 0.5 seconds when grounded


func _ready() -> void:
	_setup_phase(current_phase)
	current_health = max_health
	last_safe_position = global_position  # Initialize checkpoint
	_equip_weapon_for_phase(current_phase)  # Equip initial weapon
	print("Player initialized - Phase: %s" % GameManager.PlayerPhase.keys()[current_phase])


func _physics_process(delta: float) -> void:
	# Get input
	input_direction = _get_input_direction()

	# Update projectile cooldown
	if not can_throw_projectile:
		projectile_cooldown_timer -= delta
		if projectile_cooldown_timer <= 0:
			can_throw_projectile = true

	# Let state machine handle movement
	state_machine.physics_update(delta)

	# Apply backward limit before moving
	if camera_controller:
		var left_boundary = camera_controller.get_left_boundary()
		# If trying to move left and would go past boundary, clamp velocity
		if input_direction.x < 0 and global_position.x <= left_boundary:
			velocity.x = max(velocity.x, 0)  # Don't allow leftward velocity

	# Move
	move_and_slide()

	# Enforce hard boundary after movement (in case of knockback, etc.)
	if camera_controller:
		var left_boundary = camera_controller.get_left_boundary()
		if global_position.x < left_boundary:
			global_position.x = left_boundary
			velocity.x = max(velocity.x, 0)  # Stop leftward movement

	# Check if just landed
	if is_on_floor() and velocity.y >= 0:
		if state_machine.previous_state_name == "Fall":
			landed.emit()

	# Update checkpoint when grounded (auto-save safe position)
	if is_on_floor() and not is_dead:
		checkpoint_cooldown -= delta
		if checkpoint_cooldown <= 0:
			last_safe_position = global_position
			checkpoint_cooldown = CHECKPOINT_INTERVAL


func _get_input_direction() -> Vector2:
	"""Get player input direction"""
	var dir = Vector2.ZERO
	dir.x = Input.get_axis("move_left", "move_right")
	return dir


## Take damage with knockback (Ghosts 'n Goblins style)
func take_damage(amount: int, knockback: Vector2 = Vector2.ZERO) -> void:
	if is_invincible or is_dead:
		return

	current_health = maxi(0, current_health - amount)
	health_changed.emit(current_health, max_health)
	took_damage.emit(amount)

	# Apply knockback velocity
	if knockback != Vector2.ZERO:
		velocity = knockback
	else:
		# Default knockback if none provided
		velocity = Vector2(-200, -400)

	# Screenshake when taking damage
	if camera_controller:
		camera_controller.add_trauma(0.5)  # Strong shake when hurt

	print("Player took %d damage. Health: %d/%d" % [amount, current_health, max_health])

	if current_health <= 0:
		die()
	else:
		state_machine.change_state("Hurt")
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


## Respawn at a position
func respawn(respawn_position: Vector2 = Vector2.ZERO) -> void:
	"""Respawn player at checkpoint or start position"""
	is_dead = false
	current_health = max_health
	health_changed.emit(current_health, max_health)

	# Use last safe position if no specific position provided
	var spawn_pos = respawn_position if respawn_position != Vector2.ZERO else last_safe_position

	# Reset position
	global_position = spawn_pos
	velocity = Vector2.ZERO

	# Reset state to idle
	if state_machine:
		state_machine.change_state("Idle")

	print("Player respawned at: %s (checkpoint)" % spawn_pos)


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
	# Check if weapon is usable
	if equipped_weapon and not equipped_weapon.is_usable():
		print("Weapon is broken! Cannot attack.")
		return

	print("Player attacks!")

	# Get attack direction
	var attack_dir = 1.0 if sprite.scale.x > 0 else -1.0
	var attack_position = global_position + Vector2(attack_range * attack_dir, 0)

	# Get weapon stats
	var weapon_damage = equipped_weapon.get_effective_damage() if equipped_weapon else attack_damage
	var weapon_knockback_mult = equipped_weapon.knockback_strength if equipped_weapon else 1.0
	var weapon_color = equipped_weapon.attack_color if equipped_weapon else Color.WHITE

	# Check for enemies in range
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()

	# Create attack hitbox (rectangle)
	var shape = RectangleShape2D.new()
	shape.size = Vector2(attack_range, 80)
	query.shape = shape
	query.transform = Transform2D(0, attack_position)
	query.collision_mask = 4  # Enemy layer
	query.collide_with_areas = false
	query.collide_with_bodies = true

	# Query for overlapping enemies
	var results = space_state.intersect_shape(query, 10)

	# Damage all hit enemies
	var hit_something = false
	for result in results:
		var body = result["collider"]
		if body.has_method("take_damage"):
			var knockback = Vector2(attack_dir * 400 * weapon_knockback_mult, -250)
			body.take_damage(weapon_damage, knockback)
			print("Player hit %s for %d damage!" % [body.name, weapon_damage])
			hit_something = true

	# Degrade weapon if hit something
	if hit_something and equipped_weapon:
		var still_usable = equipped_weapon.use()
		weapon_durability_changed.emit(equipped_weapon.current_durability, equipped_weapon.max_durability)
		if not still_usable:
			print("WARNING: %s is broken!" % equipped_weapon.weapon_name)

	# Combat feedback
	if hit_something:
		# Screenshake on hit
		if camera_controller:
			camera_controller.add_trauma(0.3)  # Medium shake on hit

		# Hitstop for impact feeling
		GameManager.apply_hitstop(0.08)  # Brief freeze (80ms)

	# Visual feedback
	_show_attack_effect(attack_position, weapon_color)


func _show_attack_effect(pos: Vector2, color: Color = Color.WHITE) -> void:
	"""Show attack visual effect (placeholder)"""
	var effect_scale = equipped_weapon.effect_size if equipped_weapon else 1.0
	var effect = ColorRect.new()
	effect.size = Vector2(20 * effect_scale, 20 * effect_scale)
	effect.position = pos - effect.size / 2
	effect.color = Color(color.r, color.g, color.b, 0.7)
	get_parent().add_child(effect)

	await get_tree().create_timer(0.2).timeout
	effect.queue_free()


## Throw projectile
func throw_projectile() -> void:
	"""Throw a projectile based on current weapon"""
	if not can_throw_projectile or is_dead:
		return

	# Get projectile scene based on weapon type
	var projectile_scene: PackedScene = _get_projectile_scene()
	if not projectile_scene:
		print("No projectile scene for weapon: %s" % WeaponType.keys()[current_weapon])
		return

	# Instantiate projectile
	var projectile: Projectile = projectile_scene.instantiate()

	# Position projectile at player's weapon hand (slightly in front)
	var throw_direction = 1 if sprite.scale.x > 0 else -1
	var spawn_offset = Vector2(40 * throw_direction, -20)  # Offset from center
	projectile.global_position = global_position + spawn_offset

	# Add to scene
	get_parent().add_child(projectile)

	# Launch projectile
	projectile.launch(throw_direction, velocity * 0.3)  # Inherit some player velocity

	# Emit signal
	projectile_thrown.emit(projectile)

	# Start cooldown
	can_throw_projectile = false
	projectile_cooldown_timer = PROJECTILE_COOLDOWN

	print("Player threw %s" % WeaponType.keys()[current_weapon_type])


func _get_projectile_scene() -> PackedScene:
	"""Get the projectile scene for current weapon"""
	match current_weapon_type:
		WeaponType.DAGGER:
			return PROJECTILE_DAGGER
		WeaponType.LANCE:
			return null  # TODO: Implement lance
		WeaponType.AXE:
			return null  # TODO: Implement axe
		WeaponType.TORCH:
			return null  # TODO: Implement torch
	return null


func set_projectile_weapon(weapon: WeaponType) -> void:
	"""Change current projectile weapon"""
	if weapon == current_weapon_type:
		return

	current_weapon_type = weapon
	print("Projectile weapon changed to: %s" % WeaponType.keys()[weapon])


func equip_weapon(weapon: Weapon) -> void:
	"""Equip a melee weapon"""
	if equipped_weapon == weapon:
		return

	equipped_weapon = weapon
	weapon_changed.emit(weapon)
	weapon_durability_changed.emit(weapon.current_durability, weapon.max_durability)
	print("Equipped weapon: %s" % weapon.weapon_name)


func _equip_weapon_for_phase(phase: GameManager.PlayerPhase) -> void:
	"""Equip appropriate weapon for player phase"""
	match phase:
		GameManager.PlayerPhase.CHILD:
			equipped_weapon = WeaponWood.new()
		GameManager.PlayerPhase.ADOLESCENT:
			equipped_weapon = WeaponIron.new()
		GameManager.PlayerPhase.KNIGHT:
			equipped_weapon = WeaponTemplar.new()
		GameManager.PlayerPhase.ELDER:
			equipped_weapon = WeaponStaff.new()

	if equipped_weapon:
		weapon_changed.emit(equipped_weapon)
		weapon_durability_changed.emit(equipped_weapon.current_durability, equipped_weapon.max_durability)
		print("Auto-equipped %s for phase %s" % [equipped_weapon.weapon_name, GameManager.PlayerPhase.keys()[phase]])


func get_weapon_name() -> String:
	"""Get current weapon name for UI"""
	if equipped_weapon:
		return equipped_weapon.weapon_name
	return "No Weapon"


func get_weapon_durability() -> float:
	"""Get current weapon durability percentage"""
	if equipped_weapon:
		return equipped_weapon.get_durability_percentage()
	return 0.0


## Change player phase
func change_phase(new_phase: GameManager.PlayerPhase) -> void:
	if new_phase == current_phase:
		return

	current_phase = new_phase
	_setup_phase(new_phase)
	_equip_weapon_for_phase(new_phase)  # Equip appropriate weapon for new phase
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


## Camera setup
func set_camera_controller(camera: CameraController) -> void:
	"""Set the camera controller for boundary checking"""
	camera_controller = camera
	print("Player: Camera controller set for boundary checking")


## Getters
func get_health_percentage() -> float:
	return float(current_health) / float(max_health)


func is_facing_right() -> bool:
	return sprite.scale.x > 0


func set_facing_direction(right: bool) -> void:
	sprite.scale.x = 1.0 if right else -1.0
