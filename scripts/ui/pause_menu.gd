extends CanvasLayer
class_name PauseMenu

## PauseMenu
## Arcade-style pause menu with retro aesthetic
## Options: Continue, Restart, Options, Quit

# Signals
signal continue_pressed()
signal restart_pressed()
signal options_pressed()
signal quit_pressed()

# UI Elements
@onready var pause_overlay: ColorRect = $PauseOverlay
@onready var menu_container: VBoxContainer = $MenuContainer
@onready var pause_title: Label = $MenuContainer/PauseTitle
@onready var continue_button: Button = $MenuContainer/ButtonContainer/ContinueButton
@onready var restart_button: Button = $MenuContainer/ButtonContainer/RestartButton
@onready var options_button: Button = $MenuContainer/ButtonContainer/OptionsButton
@onready var quit_button: Button = $MenuContainer/ButtonContainer/QuitButton

# State
var is_paused: bool = false
var current_selection: int = 0
var buttons: Array[Button] = []


func _ready() -> void:
	_setup_style()
	_setup_buttons()
	hide_pause_menu()

	# Set process mode to always (works when paused)
	process_mode = Node.PROCESS_MODE_ALWAYS


func _input(event: InputEvent) -> void:
	if not visible:
		return

	# Keyboard navigation
	if event.is_action_pressed("ui_up"):
		_select_previous()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_down"):
		_select_next()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_select"):
		_activate_selected()
		get_viewport().set_input_as_handled()


func _setup_style() -> void:
	"""Setup arcade-style appearance"""
	# Pause overlay (dimmed background)
	if pause_overlay:
		pause_overlay.color = Color(0, 0, 0, 0.7)

	# Title
	if pause_title:
		pause_title.add_theme_color_override("font_color", Color(1.0, 0.2, 0.2))
		pause_title.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
		pause_title.add_theme_constant_override("outline_size", 4)


func _setup_buttons() -> void:
	"""Setup button array and connect signals"""
	buttons = [continue_button, restart_button, options_button, quit_button]

	# Connect signals
	if continue_button:
		continue_button.pressed.connect(_on_continue_pressed)
	if restart_button:
		restart_button.pressed.connect(_on_restart_pressed)
	if options_button:
		options_button.pressed.connect(_on_options_pressed)
	if quit_button:
		quit_button.pressed.connect(_on_quit_pressed)

	# Style buttons
	for i in buttons.size():
		if buttons[i]:
			_style_button(buttons[i], false)


func _style_button(button: Button, selected: bool) -> void:
	"""Style button based on selection state"""
	if not button:
		return

	if selected:
		button.add_theme_color_override("font_color", Color(1.0, 1.0, 0.2))  # Yellow
		button.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
		button.add_theme_constant_override("outline_size", 3)
		# Pulse animation
		_pulse_button(button)
	else:
		button.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))  # White
		button.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
		button.add_theme_constant_override("outline_size", 2)


func show_pause_menu() -> void:
	"""Show pause menu and pause game"""
	visible = true
	is_paused = true
	get_tree().paused = true

	current_selection = 0
	_update_selection()

	# Entry animation
	if menu_container:
		menu_container.modulate.a = 0.0
		menu_container.scale = Vector2(0.8, 0.8)

		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_BACK)

		tween.tween_property(menu_container, "modulate:a", 1.0, 0.3)
		tween.parallel().tween_property(menu_container, "scale", Vector2(1.0, 1.0), 0.3)


func hide_pause_menu() -> void:
	"""Hide pause menu and resume game"""
	visible = false
	is_paused = false
	get_tree().paused = false


func _select_next() -> void:
	"""Select next menu option"""
	current_selection = (current_selection + 1) % buttons.size()
	_update_selection()


func _select_previous() -> void:
	"""Select previous menu option"""
	current_selection = (current_selection - 1 + buttons.size()) % buttons.size()
	_update_selection()


func _update_selection() -> void:
	"""Update visual selection"""
	for i in buttons.size():
		_style_button(buttons[i], i == current_selection)


func _activate_selected() -> void:
	"""Activate currently selected button"""
	if current_selection >= 0 and current_selection < buttons.size():
		if buttons[current_selection]:
			buttons[current_selection].pressed.emit()


func _pulse_button(button: Button) -> void:
	"""Pulse animation for selected button"""
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(button, "scale", Vector2(1.05, 1.05), 0.5)
	tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.5)


## Button callbacks

func _on_continue_pressed() -> void:
	"""Continue game"""
	hide_pause_menu()
	continue_pressed.emit()


func _on_restart_pressed() -> void:
	"""Restart level"""
	hide_pause_menu()
	restart_pressed.emit()


func _on_options_pressed() -> void:
	"""Open options (placeholder)"""
	options_pressed.emit()
	print("Options menu not yet implemented")


func _on_quit_pressed() -> void:
	"""Quit to main menu"""
	hide_pause_menu()
	quit_pressed.emit()
