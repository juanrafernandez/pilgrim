extends CanvasLayer
class_name TouchControls

# Touch controls for iOS/mobile devices
# Provides virtual buttons for player input

# Node references
@onready var left_button: TouchScreenButton = $ControlsContainer/LeftButton
@onready var right_button: TouchScreenButton = $ControlsContainer/RightButton
@onready var jump_button: TouchScreenButton = $ControlsContainer/JumpButton
@onready var attack_button: TouchScreenButton = $ControlsContainer/AttackButton

# State tracking
var _left_pressed: bool = false
var _right_pressed: bool = false


func _ready() -> void:
	# Auto-hide on desktop, show on mobile
	if OS.get_name() == "Windows" or OS.get_name() == "macOS" or OS.get_name() == "Linux":
		hide()
	else:
		show()

	# Connect signals
	if left_button:
		left_button.pressed.connect(_on_left_pressed)
		left_button.released.connect(_on_left_released)

	if right_button:
		right_button.pressed.connect(_on_right_pressed)
		right_button.released.connect(_on_right_released)

	if jump_button:
		jump_button.pressed.connect(_on_jump_pressed)

	if attack_button:
		attack_button.pressed.connect(_on_attack_pressed)


func _process(_delta: float) -> void:
	"""Simulate keyboard input based on touch state"""
	# Simulate left/right arrow keys
	if _left_pressed:
		Input.action_press("move_left")
	else:
		Input.action_release("move_left")

	if _right_pressed:
		Input.action_press("move_right")
	else:
		Input.action_release("move_right")


# Button callbacks

func _on_left_pressed() -> void:
	_left_pressed = true


func _on_left_released() -> void:
	_left_pressed = false


func _on_right_pressed() -> void:
	_right_pressed = true


func _on_right_released() -> void:
	_right_pressed = false


func _on_jump_pressed() -> void:
	# Simulate jump action
	Input.action_press("jump")
	await get_tree().create_timer(0.1).timeout
	Input.action_release("jump")


func _on_attack_pressed() -> void:
	# Simulate attack action
	Input.action_press("attack")
	await get_tree().create_timer(0.1).timeout
	Input.action_release("attack")


# Public methods

func show_controls() -> void:
	"""Show touch controls"""
	show()


func hide_controls() -> void:
	"""Hide touch controls"""
	hide()


func set_controls_visible(visible: bool) -> void:
	"""Set touch controls visibility"""
	if visible:
		show_controls()
	else:
		hide_controls()
