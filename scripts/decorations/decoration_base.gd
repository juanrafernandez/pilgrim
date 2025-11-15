extends Node2D
class_name DecorationBase

## Base class for all level decorations
## Handles placement, physics, and visual layering
## Isolated and modular to avoid conflicts between branches

enum DecorationType {
	BACKGROUND,  # Behind player (trees, bushes far away)
	MIDGROUND,   # Same layer as player (rocks, obstacles)
	FOREGROUND   # In front of player (grass tufts, small details)
}

enum PlacementMode {
	GROUND_ALIGNED,  # Bottom of sprite touches ground
	FLOATING,        # Custom Y position (for clouds, etc.)
	PLATFORM_ALIGNED # Bottom touches platform
}

@export var decoration_type: DecorationType = DecorationType.MIDGROUND
@export var placement_mode: PlacementMode = PlacementMode.GROUND_ALIGNED
@export var ground_level: float = 1700.0  # Default ground Y position
@export var sprite_texture: Texture2D
@export var sprite_scale: Vector2 = Vector2(1, 1)

var sprite: Sprite2D


func _ready() -> void:
	# Set z_index based on type
	match decoration_type:
		DecorationType.BACKGROUND:
			z_index = -100
		DecorationType.MIDGROUND:
			z_index = 0
		DecorationType.FOREGROUND:
			z_index = 100

	# Create sprite if texture provided
	if sprite_texture:
		_setup_sprite()


func _setup_sprite() -> void:
	"""Create and configure sprite"""
	sprite = Sprite2D.new()
	sprite.texture = sprite_texture
	sprite.scale = sprite_scale
	add_child(sprite)

	# Apply placement mode
	_apply_placement()


func _apply_placement() -> void:
	"""Position sprite according to placement mode"""
	if not sprite or not sprite.texture:
		return

	match placement_mode:
		PlacementMode.GROUND_ALIGNED:
			_align_to_ground()
		PlacementMode.PLATFORM_ALIGNED:
			_align_to_platform()
		PlacementMode.FLOATING:
			pass  # Keep manual position


func _align_to_ground() -> void:
	"""Position sprite so bottom touches ground_level"""
	var texture_height = sprite.texture.get_height() * sprite_scale.y
	var offset_y = -(texture_height / 2.0)
	sprite.position.y = offset_y


func _align_to_platform() -> void:
	"""Position sprite on platform (similar to ground)"""
	_align_to_ground()


func set_ground_level(new_ground: float) -> void:
	"""Update ground level and reposition"""
	ground_level = new_ground
	if sprite:
		_apply_placement()


func get_sprite_bounds() -> Rect2:
	"""Get sprite bounding box in world coordinates"""
	if not sprite or not sprite.texture:
		return Rect2()

	var texture_size = sprite.texture.get_size() * sprite_scale
	var top_left = global_position - (texture_size / 2.0)
	return Rect2(top_left, texture_size)
