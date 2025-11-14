extends Node2D

## Test Scene V2
## Test scene for complete Player system with State Machine

@onready var player: Player = $Player
@onready var camera: CameraController = $Camera
@onready var health_bar: ProgressBar = $UI/HealthBar
@onready var health_label: Label = $UI/HealthLabel
@onready var phase_label: Label = $UI/PhaseLabel
@onready var state_label: Label = $UI/StateLabel
@onready var debug_label: Label = $UI/DebugLabel


func _ready() -> void:
	print("Test Scene V2 loaded - Player System Complete")

	# Setup camera for player
	player.set_camera_controller(camera)

	# Connect to player signals
	player.health_changed.connect(_on_player_health_changed)
	player.phase_changed.connect(_on_player_phase_changed)
	player.died.connect(_on_player_died)
	player.state_machine.state_changed.connect(_on_state_changed)

	# Initialize UI
	_update_ui()


func _physics_process(_delta: float) -> void:
	_update_debug_info()
	_update_state_label()
	_handle_test_input()


func _update_ui() -> void:
	"""Update all UI elements"""
	health_bar.max_value = player.max_health
	health_bar.value = player.current_health
	health_label.text = "Salud: %d/%d" % [player.current_health, player.max_health]
	phase_label.text = "Fase: %s" % GameManager.PlayerPhase.keys()[player.current_phase]


func _update_debug_info() -> void:
	"""Update debug information"""
	var fps = Engine.get_frames_per_second()
	var pos = player.global_position
	var vel = player.velocity
	var on_floor = player.is_on_floor()
	var invincible = "SÍ" if player.is_invincible else "NO"

	debug_label.text = "FPS: %d | Pos: (%.0f, %.0f) | Vel: (%.0f, %.0f) | Piso: %s | Invencible: %s" % [
		fps, pos.x, pos.y, vel.x, vel.y, "SÍ" if on_floor else "NO", invincible
	]


func _update_state_label() -> void:
	"""Update current state label"""
	if player.state_machine.current_state:
		state_label.text = "Estado: %s" % player.state_machine.get_state_name()


func _handle_test_input() -> void:
	"""Handle test-specific inputs"""
	# ESC: Return to main menu
	if Input.is_action_just_pressed("pause"):
		SceneManager.load_scene("res://scenes/main/main_menu.tscn")

	# K: Take damage (test)
	if Input.is_action_just_pressed("ui_page_up"):  # K key
		player.take_damage(20)
		print("Test: Player took 20 damage")

	# L: Change phase (test)
	if Input.is_action_just_pressed("ui_page_down"):  # L key
		var next_phase = (player.current_phase + 1) % 4
		player.change_phase(next_phase)
		print("Test: Changed to phase %s" % GameManager.PlayerPhase.keys()[next_phase])


## Signal handlers
func _on_player_health_changed(new_health: int, max_hp: int) -> void:
	health_bar.value = new_health
	health_label.text = "Salud: %d/%d" % [new_health, max_hp]

	# Color code health bar
	if new_health <= max_hp * 0.25:
		health_bar.modulate = Color(1.0, 0.0, 0.0)  # Red
	elif new_health <= max_hp * 0.5:
		health_bar.modulate = Color(1.0, 0.5, 0.0)  # Orange
	else:
		health_bar.modulate = Color(0.0, 1.0, 0.0)  # Green


func _on_player_phase_changed(new_phase: GameManager.PlayerPhase) -> void:
	phase_label.text = "Fase: %s" % GameManager.PlayerPhase.keys()[new_phase]
	print("Phase changed to: %s" % GameManager.PlayerPhase.keys()[new_phase])


func _on_player_died() -> void:
	print("Player died!")


func _on_state_changed(new_state: String) -> void:
	state_label.text = "Estado: %s" % new_state
