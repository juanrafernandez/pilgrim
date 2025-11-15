extends Projectile
class_name ProjectileDagger

## Dagger Projectile
## Fast, straight-flying weapon
## Default weapon in Ghosts 'n Goblins style


func _ready() -> void:
	super._ready()

	# Dagger properties
	damage = 10
	speed = 600.0
	lifetime = 2.0
	gravity_affected = false  # Daggers fly straight

	print("Dagger projectile created")
