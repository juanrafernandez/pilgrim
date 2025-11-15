extends Weapon
class_name WeaponTemplar

## Templar Weapon - Knight Phase
## Blessed weapon with high durability and damage
## Divine strength weapon

func _init() -> void:
	super._init(
		"Templar Blade",
		WeaponTier.TEMPLAR,
		150,  # High durability (blessed weapon)
		20,   # High damage
		0.9   # Slightly slower (heavy)
	)

	knockback_strength = 1.5  # Strong knockback
	durability_loss_per_hit = 1  # Degrades slowly (blessed)
	attack_color = Color(1.0, 1.0, 0.8)  # Holy white-gold
	effect_size = 1.2
