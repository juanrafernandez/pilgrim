extends Resource
class_name Weapon

## Base Weapon Class
## Handles weapon stats, durability, and degradation
## All weapons inherit from this class

# Signals
signal durability_changed(current: int, max: int)
signal weapon_broken()

# Enums
enum WeaponTier {
	WOOD,      # Child phase - basic wooden weapon
	IRON,      # Adolescent phase - improved iron weapon
	TEMPLAR,   # Knight phase - blessed templar weapon
	STAFF      # Elder phase - magical staff
}

# Weapon stats
@export var weapon_name: String = "Basic Weapon"
@export var weapon_tier: WeaponTier = WeaponTier.WOOD
@export var max_durability: int = 100
@export var damage: int = 10
@export var attack_speed: float = 1.0  # Multiplier (1.0 = normal, 1.5 = faster)
@export var knockback_strength: float = 1.0  # Multiplier for knockback
@export var durability_loss_per_hit: int = 2  # How much durability is lost per attack

# State
var current_durability: int = 100
var is_broken: bool = false

# Visual/Audio
@export var attack_color: Color = Color.WHITE
@export var effect_size: float = 1.0


func _init(
	p_name: String = "Basic Weapon",
	p_tier: WeaponTier = WeaponTier.WOOD,
	p_durability: int = 100,
	p_damage: int = 10,
	p_speed: float = 1.0
) -> void:
	weapon_name = p_name
	weapon_tier = p_tier
	max_durability = p_durability
	current_durability = max_durability
	damage = p_damage
	attack_speed = p_speed


## Use weapon (degrades durability)
func use() -> bool:
	"""Use the weapon, returns false if broken"""
	if is_broken:
		return false

	# Degrade durability
	current_durability = maxi(0, current_durability - durability_loss_per_hit)
	durability_changed.emit(current_durability, max_durability)

	# Check if broken
	if current_durability <= 0:
		_break_weapon()
		return false

	return true


## Repair weapon
func repair(amount: int) -> void:
	"""Repair weapon by amount"""
	if is_broken:
		# Can't repair completely broken weapon
		return

	current_durability = mini(max_durability, current_durability + amount)
	durability_changed.emit(current_durability, max_durability)
	print("%s repaired by %d. Durability: %d/%d" % [weapon_name, amount, current_durability, max_durability])


## Full restore
func restore() -> void:
	"""Fully restore weapon"""
	current_durability = max_durability
	is_broken = false
	durability_changed.emit(current_durability, max_durability)


func _break_weapon() -> void:
	"""Weapon has broken"""
	is_broken = true
	weapon_broken.emit()
	print("%s is BROKEN!" % weapon_name)


## Getters
func get_durability_percentage() -> float:
	return float(current_durability) / float(max_durability)


func get_effective_damage() -> int:
	"""Get damage adjusted by durability"""
	# Weapon does less damage when damaged
	var durability_percent = get_durability_percentage()
	if durability_percent < 0.25:
		return int(damage * 0.5)  # 50% damage when almost broken
	elif durability_percent < 0.5:
		return int(damage * 0.75)  # 75% damage when half broken
	return damage


func is_usable() -> bool:
	return not is_broken and current_durability > 0


func get_description() -> String:
	"""Get weapon description for UI"""
	var tier_name = WeaponTier.keys()[weapon_tier]
	var status = "BROKEN" if is_broken else "OK"
	return "%s (%s) - %d/%d - %s" % [weapon_name, tier_name, current_durability, max_durability, status]
