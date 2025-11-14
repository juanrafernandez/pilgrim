extends Control
class_name LevelSelect

# Level selection screen

# Node references
@onready var back_button: Button = $BackButton
@onready var level_grid: GridContainer = $ScrollContainer/LevelGrid


func _ready() -> void:
	# Connect back button
	if back_button:
		back_button.pressed.connect(_on_back_pressed)

	# Create level buttons
	_create_level_buttons()


func _create_level_buttons() -> void:
	"""Create a button for each of the 32 levels"""
	if not level_grid:
		return

	for i in range(1, 33):
		var button = Button.new()
		button.custom_minimum_size = Vector2(120, 120)
		button.text = str(i)

		# Check if level is unlocked
		var is_unlocked = _is_level_unlocked(i)

		if is_unlocked:
			button.pressed.connect(_on_level_selected.bind(i))
		else:
			button.disabled = true
			button.modulate = Color(0.5, 0.5, 0.5, 1)

		level_grid.add_child(button)


func _is_level_unlocked(level: int) -> bool:
	"""Check if a level is unlocked"""
	# For now, unlock all levels for testing
	# In production, check GameManager for completed levels
	if GameManager:
		return level <= GameManager.current_level or level == 1
	return level == 1


func _on_level_selected(level: int) -> void:
	"""Load the selected level"""
	print("[LevelSelect] Loading level ", level)

	if GameManager:
		GameManager.change_state(GameManager.GameState.PLAYING)

	if SceneManager:
		SceneManager.load_level(level)


func _on_back_pressed() -> void:
	"""Return to main menu"""
	print("[LevelSelect] Returning to main menu")

	if SceneManager:
		SceneManager.load_scene(SceneManager.SCENE_MAIN_MENU)
