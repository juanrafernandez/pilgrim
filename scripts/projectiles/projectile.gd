extends Area2D
class_name Projectile

## Base Projectile Class
## Weapons thrown by the player (daggers, lances, axes, etc.)

# Signals
signal hit_enemy(enemy: Enemy)
signal destroyed()

# Properties
@export var damage: int = 10
@export var speed: float = 500.0
@export var lifetime: float = 3.0
@export var gravity_affected: bool = true
@export var gravity_scale: float = 0.5

# State
var velocity: Vector2 = Vector2.ZERO
var direction: int = 1  # 1 for right, -1 for left
var time_alive: float = 0.0

# References
@onready var sprite: ColorRect = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	# Set collision layers (projectiles on layer 3)
	collision_layer = 4  # Layer 3 (2^2 = 4)
	collision_mask = 2   # Collide with enemies (layer 2)

	# Connect to body entered
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)


func _physics_process(delta: float) -> void:
	time_alive += delta

	# Check lifetime
	if time_alive >= lifetime:
		_destroy()
		return

	# Apply gravity if affected
	if gravity_affected:
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * gravity_scale * delta

	# Move projectile
	position += velocity * delta

	# Rotate sprite based on velocity (visual effect)
	if sprite:
		sprite.rotation = velocity.angle()


func launch(dir: int, spawn_velocity: Vector2 = Vector2.ZERO) -> void:
	"""Launch projectile in a direction"""
	direction = dir
	velocity = Vector2(speed * direction, 0) + spawn_velocity

	# Flip sprite if going left
	if sprite and direction < 0:
		sprite.scale.x = -1


func _on_body_entered(body: Node2D) -> void:
	"""Handle collision with bodies (enemies, ground)"""
	if body is Enemy:
		# Deal damage to enemy
		body.take_damage(damage)
		hit_enemy.emit(body)
		_destroy()
	elif body is TileMap or body is StaticBody2D:
		# Hit terrain
		_destroy()


func _on_area_entered(area: Area2D) -> void:
	"""Handle collision with other areas"""
	# Could be used for shields, barriers, etc.
	pass


func _destroy() -> void:
	"""Destroy projectile"""
	destroyed.emit()
	queue_free()
