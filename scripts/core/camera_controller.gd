extends Camera2D
class_name CameraController

## Camera Controller
## Follows player with scrolling boundaries and backward limit

@export var target: Node2D  # Player to follow
@export var backward_limit_distance: float = 600.0  # Max distance player can go back
@export var forward_buffer: float = 200.0  # Distance ahead of player camera can see
@export var smooth_speed: float = 5.0  # Camera smoothing
@export var vertical_offset: float = -650.0  # How far from player to position camera (negative = above player)
@export var horizontal_offset: float = 240.0  # Horizontal offset to show more ahead (player on left third)

var max_x_reached: float = 0.0  # Furthest right position reached
var min_allowed_x: float = 0.0  # Left boundary (can't go further left)


func _ready() -> void:
	# Auto-find player if no target set
	if not target:
		target = get_parent().get_node_or_null("Player")

	if target:
		global_position.x = target.global_position.x + horizontal_offset
		global_position.y = target.global_position.y + vertical_offset
		max_x_reached = target.global_position.x
		min_allowed_x = max_x_reached - backward_limit_distance
	make_current()


func _physics_process(delta: float) -> void:
	if not target:
		return

	# Update max position reached (camera advances with player)
	if target.global_position.x > max_x_reached:
		max_x_reached = target.global_position.x
		min_allowed_x = max_x_reached - backward_limit_distance

	# Calculate target camera position with horizontal offset (player on left side)
	var target_x = target.global_position.x + horizontal_offset

	# Clamp target to minimum allowed position
	target_x = max(target_x, min_allowed_x + forward_buffer)

	# Smooth camera movement
	var new_x = lerp(global_position.x, target_x, smooth_speed * delta)
	global_position.x = new_x

	# Y follows player with offset (shows more ground below)
	global_position.y = target.global_position.y + vertical_offset


func get_left_boundary() -> float:
	"""Returns the left boundary position"""
	return min_allowed_x


func is_at_left_boundary(position_x: float) -> bool:
	"""Check if a position is at or beyond the left boundary"""
	return position_x <= min_allowed_x
