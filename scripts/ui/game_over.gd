extends Control
class_name GameOver

# Game Over screen controller

# Node references
@onready var retry_button: Button = $Panel/MenuContainer/RetryButton
@onready var main_menu_button: Button = $Panel/MenuContainer/MainMenuButton
@onready var stats_label: Label = $Panel/StatsLabel


func _ready() -> void:
	# Connect button signals
	if retry_button:
		retry_button.pressed.connect(_on_retry_pressed)

	if main_menu_button:
		main_menu_button.pressed.connect(_on_main_menu_pressed)

	# Update stats
	_update_stats()

	# Set game state
	if GameManager:
		GameManager.change_state(GameManager.GameState.GAME_OVER)

	# Play game over music
	if AudioManager:
		AudioManager.play_music("game_over")


func _update_stats() -> void:
	"""Update the stats display"""
	if not stats_label or not GameManager:
		return

	var stats_text = ""
	stats_text += "Level: %d\n" % GameManager.current_level
	stats_text += "Virtue: %d\n" % GameManager.virtue_points
	stats_text += "Lives Remaining: %d" % GameManager.lives

	stats_label.text = stats_text


func _on_retry_pressed() -> void:
	"""Retry from level 1"""
	print("[GameOver] Retrying game")

	# Reset game
	if GameManager:
		GameManager.reset_game()
		GameManager.change_state(GameManager.GameState.PLAYING)

	# Load first level
	if SceneManager:
		SceneManager.load_level(1)


func _on_main_menu_pressed() -> void:
	"""Return to main menu"""
	print("[GameOver] Returning to main menu")

	# Reset game state
	if GameManager:
		GameManager.reset_game()

	# Load main menu
	if SceneManager:
		SceneManager.load_scene(SceneManager.SCENE_MAIN_MENU)
