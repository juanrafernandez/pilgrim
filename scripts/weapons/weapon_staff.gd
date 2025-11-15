extends Weapon
class_name WeaponStaff

## Staff Weapon - Elder Phase
## Magical staff with magical properties
## Lower physical damage but doesn't degrade as much

func _init() -> void:
	super._init(
		"Elder's Staff",
		WeaponTier.STAFF,
		120,  # Good durability
		15,   # Moderate damage
		1.1   # Slightly faster
	)

	knockback_strength = 0.8  # Less physical knockback
	durability_loss_per_hit = 1  # Magical, doesn't degrade much
	attack_color = Color(0.6, 0.4, 0.9)  # Purple (magical)
	effect_size = 1.0
