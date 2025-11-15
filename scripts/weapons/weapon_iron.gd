extends Weapon
class_name WeaponIron

## Iron Weapon - Adolescent Phase
## Balanced weapon with decent durability and damage
## Standard attack speed

func _init() -> void:
	super._init(
		"Iron Sword",
		WeaponTier.IRON,
		100,  # Standard durability
		12,   # Decent damage
		1.0   # Normal attack speed
	)

	knockback_strength = 1.0  # Standard knockback
	durability_loss_per_hit = 2  # Normal degradation
	attack_color = Color(0.7, 0.7, 0.8)  # Steel gray
	effect_size = 1.0
