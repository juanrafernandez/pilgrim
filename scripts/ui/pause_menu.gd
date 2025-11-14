extends Control
class_name PauseMenu

# Pause menu controller

signal resume_requested()
signal main_menu_requested()

# Node references
@onready var resume_button: Button = $Panel/MenuContainer/ResumeButton
@onready var restart_button: Button = $Panel/MenuContainer/RestartButton
@onready var main_menu_button: Button = $Panel/MenuContainer/MainMenuButton


func _ready() -> void:
	# Connect button signals
	if resume_button:
		resume_button.pressed.connect(_on_resume_pressed)

	if restart_button:
		restart_button.pressed.connect(_on_restart_pressed)

	if main_menu_button:
		main_menu_button.pressed.connect(_on_main_menu_pressed)

	# Hide by default
	hide()


func _unhandled_input(event: InputEvent) -> void:
	"""Handle pause input"""
	if event.is_action_pressed("pause"):
		if visible:
			_on_resume_pressed()
		else:
			show_pause_menu()
		get_viewport().set_input_as_handled()


func show_pause_menu() -> void:
	"""Show the pause menu"""
	show()
	get_tree().paused = true

	if GameManager:
		GameManager.change_state(GameManager.GameState.PAUSED)


func hide_pause_menu() -> void:
	"""Hide the pause menu"""
	hide()
	get_tree().paused = false

	if GameManager:
		GameManager.change_state(GameManager.GameState.PLAYING)


func _on_resume_pressed() -> void:
	"""Resume game"""
	print("[PauseMenu] Resuming game")
	hide_pause_menu()
	resume_requested.emit()


func _on_restart_pressed() -> void:
	"""Restart current level"""
	print("[PauseMenu] Restarting level")
	hide_pause_menu()

	# Reload current level
	if GameManager and SceneManager:
		SceneManager.load_level(GameManager.current_level)


func _on_main_menu_pressed() -> void:
	"""Return to main menu"""
	print("[PauseMenu] Returning to main menu")
	hide_pause_menu()

	if SceneManager:
		SceneManager.load_scene(SceneManager.SCENE_MAIN_MENU)

	main_menu_requested.emit()
