extends Resource
class_name Shield

## Shield Defense System
## Manages shield energy, blocking, damage reduction, and perfect parry mechanics
## Works alongside weapon system - provides defensive capabilities

# Signals
signal energy_changed(current: int, max: int)
signal perfect_parry_triggered(damage_returned: int)
signal shield_depleted()
signal shield_recharged()
signal block_started()
signal block_ended()

# Constants
const DEFAULT_MAX_ENERGY: int = 100
const DEFAULT_CONSUMPTION_RATE: float = 10.0  # Energy per second while blocking
const DEFAULT_REGEN_RATE: float = 5.0  # Energy per second when not blocking
const DEFAULT_DAMAGE_REDUCTION: float = 0.75  # 75% damage reduction
const PERFECT_PARRY_WINDOW: float = 0.2  # 200ms window for perfect parry
const MIN_ENERGY_TO_BLOCK: int = 1  # Minimum energy needed to start blocking

# Shield stats
@export var max_energy: int = DEFAULT_MAX_ENERGY
@export var energy_consumption_rate: float = DEFAULT_CONSUMPTION_RATE
@export var energy_regen_rate: float = DEFAULT_REGEN_RATE
@export var damage_reduction: float = DEFAULT_DAMAGE_REDUCTION

# State
var current_energy: int = DEFAULT_MAX_ENERGY
var is_blocking: bool = false
var is_depleted: bool = false

# Parry system
var parry_timer: float = 0.0
var parry_window_active: bool = false
var last_parry_damage: int = 0


func _init() -> void:
	current_energy = max_energy


## Update shield (call every frame)
func update(delta: float) -> void:
	"""Update shield energy consumption/regeneration and parry timing"""

	# Update parry window timer
	if parry_window_active:
		parry_timer += delta
		if parry_timer >= PERFECT_PARRY_WINDOW:
			parry_window_active = false
			parry_timer = 0.0

	# Energy consumption while blocking
	if is_blocking:
		_consume_energy(energy_consumption_rate * delta)
	else:
		# Energy regeneration when not blocking
		_regenerate_energy(energy_regen_rate * delta)


## Start blocking
func start_block() -> bool:
	"""Start blocking. Returns false if not enough energy."""
	if current_energy < MIN_ENERGY_TO_BLOCK:
		print("Shield: Not enough energy to block!")
		return false

	if is_blocking:
		return true  # Already blocking

	is_blocking = true

	# Start parry window when block starts
	parry_window_active = true
	parry_timer = 0.0

	block_started.emit()
	print("Shield: Block started (Energy: %d/%d)" % [current_energy, max_energy])

	return true


## Stop blocking
func stop_block() -> void:
	"""Stop blocking"""
	if not is_blocking:
		return

	is_blocking = false
	parry_window_active = false
	parry_timer = 0.0

	block_ended.emit()
	print("Shield: Block ended (Energy: %d/%d)" % [current_energy, max_energy])


## Check if can parry
func is_in_parry_window() -> bool:
	"""Returns true if currently in perfect parry window"""
	return parry_window_active and parry_timer <= PERFECT_PARRY_WINDOW


## Reduce incoming damage
func reduce_damage(incoming_damage: int) -> int:
	"""Reduce incoming damage based on shield state. Returns actual damage taken."""

	# No shield effect if not blocking or depleted
	if not is_blocking or is_depleted:
		return incoming_damage

	# Perfect parry - return all damage to attacker
	if is_in_parry_window():
		last_parry_damage = incoming_damage
		perfect_parry_triggered.emit(incoming_damage)
		print("Shield: PERFECT PARRY! Returning %d damage to attacker!" % incoming_damage)
		return 0  # Player takes no damage

	# Normal block - reduce damage
	var reduced_damage = int(incoming_damage * (1.0 - damage_reduction))
	print("Shield: Blocked! Reduced %d damage to %d (%.0f%% reduction)" %
		[incoming_damage, reduced_damage, damage_reduction * 100])

	return reduced_damage


## Get last parry damage (for returning to attacker)
func get_last_parry_damage() -> int:
	"""Returns the damage from the last perfect parry (to be dealt to attacker)"""
	return last_parry_damage


## Consume energy
func _consume_energy(amount: float) -> void:
	"""Consume shield energy"""
	var old_energy = current_energy
	current_energy = maxi(0, current_energy - int(amount))

	# Check if depleted
	if current_energy <= 0 and not is_depleted:
		is_depleted = true
		is_blocking = false
		shield_depleted.emit()
		print("Shield: DEPLETED!")

	# Emit signal if energy changed
	if current_energy != old_energy:
		energy_changed.emit(current_energy, max_energy)


## Regenerate energy
func _regenerate_energy(amount: float) -> void:
	"""Regenerate shield energy"""
	if current_energy >= max_energy:
		return

	var old_energy = current_energy
	var was_depleted = is_depleted

	current_energy = mini(max_energy, current_energy + int(amount))

	# Check if recharged from depletion
	if was_depleted and current_energy >= MIN_ENERGY_TO_BLOCK:
		is_depleted = false
		shield_recharged.emit()
		print("Shield: Recharged!")

	# Emit signal if energy changed
	if current_energy != old_energy:
		energy_changed.emit(current_energy, max_energy)


## Restore energy
func restore_energy(amount: int) -> void:
	"""Restore shield energy by amount (e.g., from pickups)"""
	_regenerate_energy(float(amount))
	print("Shield: Restored %d energy. Energy: %d/%d" % [amount, current_energy, max_energy])


## Full restore
func restore() -> void:
	"""Fully restore shield energy"""
	current_energy = max_energy
	is_depleted = false
	energy_changed.emit(current_energy, max_energy)
	print("Shield: Fully restored!")


## Getters
func get_energy_percentage() -> float:
	"""Get shield energy as percentage (0.0 to 1.0)"""
	return float(current_energy) / float(max_energy)


func can_block() -> bool:
	"""Returns true if shield has enough energy to block"""
	return current_energy >= MIN_ENERGY_TO_BLOCK and not is_depleted


func get_status() -> String:
	"""Get shield status description for UI"""
	var status = "DEPLETED" if is_depleted else "OK"
	var blocking = " [BLOCKING]" if is_blocking else ""
	var parrying = " [PARRY WINDOW]" if is_in_parry_window() else ""
	return "Shield: %d/%d - %s%s%s" % [current_energy, max_energy, status, blocking, parrying]
