extends Node
class_name PlayerState

## Base class for all player states
## Override the virtual methods to implement state behavior

# References (set by StateMachine)
var state_machine: PlayerStateMachine
var player: Player


## Called once when state is initialized
func _state_init() -> void:
	pass


## Called when entering this state
func _state_enter() -> void:
	pass


## Called when exiting this state
func _state_exit() -> void:
	pass


## Called every physics frame (60 FPS)
func _state_physics_update(delta: float) -> void:
	pass


## Called every frame
func _state_process_update(delta: float) -> void:
	pass


## Helper: Apply gravity
func apply_gravity(delta: float) -> void:
	if not player.is_on_floor():
		player.velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta


## Helper: Apply horizontal movement with acceleration
func apply_movement(direction: float, delta: float) -> void:
	if direction != 0:
		player.velocity.x = move_toward(player.velocity.x, direction * player.SPEED, player.ACCELERATION * delta)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.FRICTION * delta)


## Helper: Update sprite direction
func update_sprite_direction() -> void:
	if player.input_direction.x > 0:
		player.set_facing_direction(true)
	elif player.input_direction.x < 0:
		player.set_facing_direction(false)


## Helper: Check for state transitions
func check_transitions() -> void:
	# Override in specific states
	pass
