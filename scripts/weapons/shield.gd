extends Resource
class_name Shield

## Shield Class
## Handles shield stats, durability, and block mechanics
## Used by player for defensive actions

# Signals
signal durability_changed(current: int, max: int)
signal shield_broken()
signal block_successful()

# Enums
enum ShieldTier {
	WOOD,      # Child phase - basic wooden shield
	IRON,      # Adolescent phase - iron shield
	TEMPLAR,   # Knight phase - blessed templar shield
	FAITH      # Elder phase - shield of faith
}

# Shield stats
@export var shield_name: String = "Basic Shield"
@export var shield_tier: ShieldTier = ShieldTier.WOOD
@export var max_durability: int = 100
@export var block_percentage: float = 0.5  # % of damage blocked (0.5 = 50%)
@export var stamina_cost: int = 10  # Stamina cost per block
@export var durability_loss_per_block: int = 3  # Durability lost per block

# State
var current_durability: int = 100
var is_broken: bool = false
var is_blocking: bool = false

# Visual
@export var shield_color: Color = Color(0.6, 0.4, 0.2)  # Brown wood color
@export var effect_size: float = 1.0


func _init(
	p_name: String = "Basic Shield",
	p_tier: ShieldTier = ShieldTier.WOOD,
	p_durability: int = 100,
	p_block: float = 0.5
) -> void:
	shield_name = p_name
	shield_tier = p_tier
	max_durability = p_durability
	current_durability = max_durability
	block_percentage = p_block


## Use shield to block (degrades durability)
func block() -> bool:
	"""Use the shield to block, returns false if broken"""
	if is_broken:
		return false

	# Degrade durability
	current_durability = maxi(0, current_durability - durability_loss_per_block)
	durability_changed.emit(current_durability, max_durability)

	# Check if broken
	if current_durability <= 0:
		_break_shield()
		return false

	block_successful.emit()
	return true


## Calculate damage after block
func calculate_blocked_damage(incoming_damage: int) -> int:
	"""Returns the damage that gets through the shield"""
	if is_broken or not is_blocking:
		return incoming_damage

	var blocked_amount = int(incoming_damage * block_percentage)
	var damage_taken = incoming_damage - blocked_amount
	return damage_taken


## Repair shield
func repair(amount: int) -> void:
	"""Repair shield by amount"""
	if is_broken:
		return

	current_durability = mini(max_durability, current_durability + amount)
	durability_changed.emit(current_durability, max_durability)


## Full restore
func restore() -> void:
	"""Fully restore shield"""
	current_durability = max_durability
	is_broken = false
	durability_changed.emit(current_durability, max_durability)


func _break_shield() -> void:
	"""Shield has broken"""
	is_broken = true
	is_blocking = false
	shield_broken.emit()
	print("%s is BROKEN!" % shield_name)


## Getters
func get_durability_percentage() -> float:
	return float(current_durability) / float(max_durability)


func is_usable() -> bool:
	return not is_broken and current_durability > 0


func get_description() -> String:
	"""Get shield description for UI"""
	var tier_name = ShieldTier.keys()[shield_tier]
	var status = "BROKEN" if is_broken else "OK"
	return "%s (%s) - %d/%d - %s" % [shield_name, tier_name, current_durability, max_durability, status]
