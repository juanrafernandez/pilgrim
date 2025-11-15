extends Node
class_name PlayerStateMachine

## Player State Machine
## Manages player states and transitions

# Signals
signal state_changed(new_state: String)

# States
var states: Dictionary = {}
var current_state: PlayerState = null
var previous_state_name: String = ""

# Reference to player
@onready var player: Player = get_parent()


func _ready() -> void:
	# Wait for player to be ready
	await player.ready

	# Initialize all child states
	for child in get_children():
		if child is PlayerState:
			states[child.name] = child
			child.state_machine = self
			child.player = player
			child._state_init()

	# Start with Idle state
	if "Idle" in states:
		change_state("Idle")
	else:
		push_error("PlayerStateMachine: No Idle state found!")


func physics_update(delta: float) -> void:
	"""Called every physics frame"""
	if current_state:
		current_state._state_physics_update(delta)


func process_update(delta: float) -> void:
	"""Called every frame"""
	if current_state:
		current_state._state_process_update(delta)


func change_state(new_state_name: String) -> void:
	"""Change to a new state"""
	if new_state_name == "":
		return

	if new_state_name not in states:
		push_error("PlayerStateMachine: State '%s' not found!" % new_state_name)
		return

	# Exit current state
	if current_state:
		previous_state_name = current_state.name
		current_state._state_exit()

	# Enter new state
	current_state = states[new_state_name]
	current_state._state_enter()

	state_changed.emit(new_state_name)
	# print("State: %s -> %s" % [previous_state_name, new_state_name])


func get_state_name() -> String:
	return current_state.name if current_state else ""
