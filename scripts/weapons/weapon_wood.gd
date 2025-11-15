extends Weapon
class_name WeaponWood

## Wooden Weapon - Child Phase
## Basic weapon with low durability and damage
## Fast attack speed to compensate

func _init() -> void:
	super._init(
		"Wooden Stick",
		WeaponTier.WOOD,
		80,   # BUFFED: 80 durability (was 60) - less punishing for beginners
		8,    # Low damage
		1.3   # Faster attacks
	)

	knockback_strength = 0.7  # Less knockback
	durability_loss_per_hit = 2  # BUFFED: 2 loss/hit (was 3) - now lasts 40 hits instead of 20
	attack_color = Color(0.6, 0.4, 0.2)  # Brown
	effect_size = 0.8
