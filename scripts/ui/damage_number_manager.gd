extends Node2D
class_name DamageNumberManager

## DamageNumberManager
## Manages spawning of floating damage numbers
## Should be added to the scene (not autoload) to handle world coordinates

# Preload damage number scene
const DamageNumberScene = preload("res://scripts/ui/damage_number.gd")


func spawn_damage_number(world_position: Vector2, damage: int, type: DamageNumber.DamageType = DamageNumber.DamageType.NORMAL) -> void:
	"""Spawn a floating damage number at world position"""
	var damage_num = DamageNumber.new()
	add_child(damage_num)

	damage_num.global_position = world_position
	damage_num.setup(damage, type)


func spawn_normal_damage(world_position: Vector2, damage: int) -> void:
	"""Spawn normal white damage number"""
	spawn_damage_number(world_position, damage, DamageNumber.DamageType.NORMAL)


func spawn_critical_damage(world_position: Vector2, damage: int) -> void:
	"""Spawn yellow critical damage number"""
	spawn_damage_number(world_position, damage, DamageNumber.DamageType.CRITICAL)


func spawn_virtue_gain(world_position: Vector2, virtue: int) -> void:
	"""Spawn gold virtue gain number"""
	spawn_damage_number(world_position, virtue, DamageNumber.DamageType.VIRTUE)


func spawn_healing(world_position: Vector2, amount: int) -> void:
	"""Spawn green healing number"""
	spawn_damage_number(world_position, amount, DamageNumber.DamageType.HEALING)
