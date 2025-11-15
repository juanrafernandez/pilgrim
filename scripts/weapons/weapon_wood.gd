extends Weapon
class_name WeaponWood

## Wooden Weapon - Child Phase
## Basic weapon with low durability and damage
## Fast attack speed to compensate

func _init() -> void:
	super._init(
		"Wooden Stick",
		WeaponTier.WOOD,
		60,   # Low durability
		8,    # Low damage
		1.3   # Faster attacks
	)

	knockback_strength = 0.7  # Less knockback
	durability_loss_per_hit = 3  # Degrades faster (fragile)
	attack_color = Color(0.6, 0.4, 0.2)  # Brown
	effect_size = 0.8
