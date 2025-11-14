extends CanvasLayer
class_name HUD

# Heads-Up Display for player information during gameplay

# Node references
@onready var health_bar: ProgressBar = $HUDContainer/TopBar/HealthContainer/HealthBar
@onready var health_label: Label = $HUDContainer/TopBar/HealthContainer/HealthLabel
@onready var virtue_bar: ProgressBar = $HUDContainer/TopBar/VirtueContainer/VirtueBar
@onready var virtue_label: Label = $HUDContainer/TopBar/VirtueContainer/VirtueLabel
@onready var level_label: Label = $HUDContainer/TopBar/LevelLabel
@onready var lives_label: Label = $HUDContainer/TopBar/LivesLabel

# Variables
var player: Player = null


func _ready() -> void:
	# Connect to GameManager signals
	if GameManager:
		GameManager.state_changed.connect(_on_game_state_changed)

	# Update initial values
	_update_hud()


func set_player(p: Player) -> void:
	"""Set the player reference and connect to signals"""
	player = p

	if player:
		player.health_changed.connect(_on_player_health_changed)
		player.virtue_action_performed.connect(_on_virtue_action_performed)


func _update_hud() -> void:
	"""Update all HUD elements"""
	_update_health()
	_update_virtue()
	_update_level()
	_update_lives()


func _update_health() -> void:
	"""Update health display"""
	if not health_bar or not health_label:
		return

	var current_health = 100
	var max_health = 100

	if player:
		current_health = player.current_health
		max_health = player.max_health
	elif GameManager:
		current_health = GameManager.player_health
		max_health = 100

	health_bar.max_value = max_health
	health_bar.value = current_health
	health_label.text = "Health: %d/%d" % [current_health, max_health]

	# Change color based on health percentage
	var health_percent = float(current_health) / float(max_health)
	if health_percent > 0.6:
		health_bar.modulate = Color(0.2, 0.8, 0.2)  # Green
	elif health_percent > 0.3:
		health_bar.modulate = Color(0.9, 0.7, 0.2)  # Yellow
	else:
		health_bar.modulate = Color(0.9, 0.2, 0.2)  # Red


func _update_virtue() -> void:
	"""Update virtue display"""
	if not virtue_bar or not virtue_label:
		return

	var virtue = 0

	if GameManager:
		virtue = GameManager.virtue_points

	virtue_bar.max_value = GameManager.MAX_VIRTUE if GameManager else 1000
	virtue_bar.value = virtue
	virtue_label.text = "Virtue: %d" % virtue

	# Change color based on virtue level
	if virtue >= 700:
		virtue_bar.modulate = Color(1, 0.9, 0.4)  # Gold
	elif virtue >= 400:
		virtue_bar.modulate = Color(0.4, 0.7, 1)  # Blue
	else:
		virtue_bar.modulate = Color(0.6, 0.6, 0.6)  # Gray


func _update_level() -> void:
	"""Update level display"""
	if not level_label:
		return

	var level = 1
	var phase = "Child"

	if GameManager:
		level = GameManager.current_level

		match GameManager.player_phase:
			GameManager.PlayerPhase.CHILD:
				phase = "Child"
			GameManager.PlayerPhase.ADOLESCENT:
				phase = "Adolescent"
			GameManager.PlayerPhase.KNIGHT:
				phase = "Knight"
			GameManager.PlayerPhase.ELDER:
				phase = "Elder"

	level_label.text = "Level %d - %s" % [level, phase]


func _update_lives() -> void:
	"""Update lives display"""
	if not lives_label:
		return

	var lives = 3

	if GameManager:
		lives = GameManager.lives

	lives_label.text = "Lives: %d" % lives


# Signal handlers

func _on_player_health_changed(_new_health: int, _max_health: int) -> void:
	"""React to player health changes"""
	_update_health()


func _on_virtue_action_performed(_virtue_type: String, _amount: int) -> void:
	"""React to virtue changes"""
	_update_virtue()


func _on_game_state_changed(new_state: GameManager.GameState) -> void:
	"""React to game state changes"""
	match new_state:
		GameManager.GameState.PLAYING:
			show()
			_update_hud()
		GameManager.GameState.PAUSED:
			# Keep showing HUD when paused
			pass
		GameManager.GameState.MAIN_MENU, GameManager.GameState.LEVEL_TRANSITION:
			hide()
		GameManager.GameState.GAME_OVER, GameManager.GameState.VICTORY:
			hide()


func _process(_delta: float) -> void:
	"""Update HUD every frame (for live updates)"""
	# Update level and lives (these can change without signals)
	_update_level()
	_update_lives()
