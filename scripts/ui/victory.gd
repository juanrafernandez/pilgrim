extends Control
class_name Victory

# Victory screen controller for game completion

# Node references
@onready var main_menu_button: Button = $Panel/MenuContainer/MainMenuButton
@onready var stats_label: Label = $Panel/StatsLabel
@onready var message_label: Label = $Panel/MessageLabel


func _ready() -> void:
	# Connect button signals
	if main_menu_button:
		main_menu_button.pressed.connect(_on_main_menu_pressed)

	# Update stats
	_update_stats()

	# Set game state
	if GameManager:
		GameManager.change_state(GameManager.GameState.VICTORY)

	# Play victory music
	if AudioManager:
		AudioManager.play_music("victory")


func _update_stats() -> void:
	"""Update the final stats display"""
	if not stats_label or not GameManager:
		return

	var stats_text = ""
	stats_text += "Levels Completed: 32\n"
	stats_text += "Final Virtue: %d / 1000\n" % GameManager.virtue_points
	stats_text += "Lives Remaining: %d\n" % GameManager.lives

	stats_label.text = stats_text

	# Update message based on virtue
	if message_label:
		var message = _get_virtue_message(GameManager.virtue_points)
		message_label.text = message


func _get_virtue_message(virtue: int) -> String:
	"""Get ending message based on virtue points"""
	if virtue >= 800:
		return "A true Templar of the highest virtue.\nYour pilgrimage is complete."
	elif virtue >= 600:
		return "A noble pilgrim, walking the path of righteousness.\nYour journey honors the Way."
	elif virtue >= 400:
		return "A faithful traveler, though the path was difficult.\nYou have completed your pilgrimage."
	elif virtue >= 200:
		return "The journey was hard and mistakes were made.\nBut you persevered to the end."
	else:
		return "The path was dark and difficult.\nYet somehow, you reached Santiago."


func _on_main_menu_pressed() -> void:
	"""Return to main menu"""
	print("[Victory] Returning to main menu")

	# Reset game state
	if GameManager:
		GameManager.reset_game()

	# Load main menu
	if SceneManager:
		SceneManager.load_scene(SceneManager.SCENE_MAIN_MENU)
