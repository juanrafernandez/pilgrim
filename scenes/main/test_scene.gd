extends Node2D

## Test Scene
## Simple scene to test that Godot project works
## Player: Green rectangle that can move and jump

@onready var player: CharacterBody2D = $Player
@onready var debug_label: Label = $UI/DebugLabel

# Player movement constants
const SPEED: float = 400.0
const JUMP_VELOCITY: float = -800.0
const GRAVITY: float = 2000.0


func _ready() -> void:
	print("Test Scene loaded")

	# Setup collision shapes (doing it in code since we don't have proper shapes yet)
	_setup_collision_shapes()

	# Managers are now autoloaded, so they're available globally
	print("GameManager ready: ", GameManager != null)
	print("SceneManager ready: ", SceneManager != null)
	print("AudioManager ready: ", AudioManager != null)


func _setup_collision_shapes() -> void:
	"""Create collision shapes programmatically"""
	# Player collision
	var player_collision = player.get_node("CollisionShape2D")
	var player_shape = RectangleShape2D.new()
	player_shape.size = Vector2(64, 96)
	player_collision.shape = player_shape

	# Ground collision
	var ground = $Ground
	var ground_collision = ground.get_node("CollisionShape2D")
	var ground_shape = RectangleShape2D.new()
	ground_shape.size = Vector2(1080, 220)
	ground_collision.position = Vector2(540, 110)
	ground_collision.shape = ground_shape


func _physics_process(delta: float) -> void:
	_handle_player_movement(delta)
	_update_debug_info()
	_handle_input()


func _handle_player_movement(delta: float) -> void:
	"""Simple player movement"""
	# Gravity
	if not player.is_on_floor():
		player.velocity.y += GRAVITY * delta

	# Jump
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.velocity.y = JUMP_VELOCITY

	# Horizontal movement
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		player.velocity.x = direction * SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, SPEED * delta * 10)

	player.move_and_slide()


func _update_debug_info() -> void:
	"""Update debug information"""
	var fps = Engine.get_frames_per_second()
	var pos = player.global_position
	var vel = player.velocity
	var on_floor = player.is_on_floor()

	debug_label.text = "FPS: %d | Pos: (%.0f, %.0f) | Vel: (%.0f, %.0f) | Floor: %s" % [
		fps, pos.x, pos.y, vel.x, vel.y, "YES" if on_floor else "NO"
	]


func _handle_input() -> void:
	"""Handle special inputs"""
	if Input.is_action_just_pressed("pause"):
		# Return to main menu
		SceneManager.load_scene("res://scenes/main/main_menu.tscn")
