extends DecorationBase
class_name DecorationObstacle

## Obstacle decoration with physics collision
## Used for rocks, fallen logs, etc. that player must jump over or avoid

enum ObstacleSize {
	SMALL,   # Jumpable easily
	MEDIUM,  # Requires good jump
	LARGE    # Must go around
}

@export var obstacle_size: ObstacleSize = ObstacleSize.MEDIUM
@export var has_collision: bool = true
@export var collision_margin: Vector2 = Vector2(4, 4)  # Shrink collision slightly

var collision_body: StaticBody2D
var collision_shape: CollisionShape2D


func _ready() -> void:
	super._ready()

	if has_collision:
		_setup_collision()


func _setup_collision() -> void:
	"""Create physics collision for obstacle"""
	collision_body = StaticBody2D.new()
	collision_body.collision_layer = 2  # Terrain layer
	collision_body.collision_mask = 1   # Player layer
	add_child(collision_body)

	collision_shape = CollisionShape2D.new()
	collision_body.add_child(collision_shape)

	# Create collision shape based on sprite size
	if sprite and sprite.texture:
		_create_collision_shape()


func _create_collision_shape() -> void:
	"""Generate collision shape from sprite dimensions"""
	var texture_size = sprite.texture.get_size() * sprite_scale

	# Shrink collision by margin for better feel
	var collision_size = texture_size - (collision_margin * 2)

	# Use rectangle shape
	var rect_shape = RectangleShape2D.new()
	rect_shape.size = collision_size
	collision_shape.shape = rect_shape

	# Position collision at sprite center, slightly raised from bottom
	# This makes jumping over feel more natural
	var raise_amount = texture_size.y * 0.1
	collision_shape.position = Vector2(0, -raise_amount)


func get_jump_difficulty() -> float:
	"""Return estimated difficulty to jump over (0-1)"""
	match obstacle_size:
		ObstacleSize.SMALL:
			return 0.2
		ObstacleSize.MEDIUM:
			return 0.5
		ObstacleSize.LARGE:
			return 1.0
	return 0.5
