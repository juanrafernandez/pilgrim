extends Control
class_name MainMenu

# Main menu controller for Camino Maldito

# Node references
@onready var play_button: Button = $MenuContainer/PlayButton
@onready var level_select_button: Button = $MenuContainer/LevelSelectButton
@onready var settings_button: Button = $MenuContainer/SettingsButton
@onready var quit_button: Button = $MenuContainer/QuitButton
@onready var title_label: Label = $TitleContainer/TitleLabel


func _ready() -> void:
	# Connect button signals
	if play_button:
		play_button.pressed.connect(_on_play_pressed)

	if level_select_button:
		level_select_button.pressed.connect(_on_level_select_pressed)

	if settings_button:
		settings_button.pressed.connect(_on_settings_pressed)

	if quit_button:
		quit_button.pressed.connect(_on_quit_pressed)

	# Set game state to main menu
	if GameManager:
		GameManager.change_state(GameManager.GameState.MAIN_MENU)

	# Play menu music
	if AudioManager:
		AudioManager.play_music("main_menu")


func _on_play_pressed() -> void:
	"""Start new game from level 1"""
	print("[MainMenu] Starting new game")

	# Reset game state
	if GameManager:
		GameManager.reset_game()
		GameManager.change_state(GameManager.GameState.PLAYING)

	# Load first level
	if SceneManager:
		SceneManager.load_level(1)


func _on_level_select_pressed() -> void:
	"""Open level selection screen"""
	print("[MainMenu] Opening level select")

	if SceneManager:
		SceneManager.load_scene(SceneManager.SCENE_LEVEL_SELECT)


func _on_settings_pressed() -> void:
	"""Open settings screen"""
	print("[MainMenu] Opening settings (not implemented yet)")
	# TODO: Create settings scene
	_show_message("Settings not yet implemented")


func _on_quit_pressed() -> void:
	"""Quit the game"""
	print("[MainMenu] Quitting game")
	get_tree().quit()


func _show_message(message: String) -> void:
	"""Show a temporary message to the player"""
	print("[MainMenu] ", message)
	# TODO: Show on-screen notification when UI is polished
