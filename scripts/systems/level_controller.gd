extends Node2D
class_name LevelController

# Level controller for managing level logic, goals, and progression

# Signals
signal level_completed()
signal level_failed()
signal checkpoint_reached(checkpoint_id: int)

# Exported variables
@export var level_number: int = 1
@export var level_name: String = "First Steps"
@export var level_phase: GameManager.PlayerPhase = GameManager.PlayerPhase.CHILD
@export var required_virtue: int = 0  # Minimum virtue to complete level
@export var time_limit: float = 0.0  # 0 = no time limit

# Private variables
var _player: Player = null
var _level_goal: Area2D = null
var _start_time: float = 0.0
var _level_completed: bool = false


func _ready() -> void:
	# Find player
	_player = get_node_or_null("Player")
	if _player:
		_player.died.connect(_on_player_died)

	# Find level goal
	_level_goal = get_node_or_null("LevelGoal")
	if _level_goal:
		_level_goal.body_entered.connect(_on_goal_area_entered)

	# Update GameManager
	if GameManager:
		GameManager.current_level = level_number
		GameManager.player_phase = level_phase

	_start_time = Time.get_ticks_msec() / 1000.0


func _process(_delta: float) -> void:
	# Check time limit
	if time_limit > 0 and not _level_completed:
		var elapsed_time = (Time.get_ticks_msec() / 1000.0) - _start_time
		if elapsed_time >= time_limit:
			_on_time_expired()


func _on_goal_area_entered(body: Node2D) -> void:
	"""Called when something enters the level goal area"""
	if body is Player and not _level_completed:
		_complete_level()


func _complete_level() -> void:
	"""Complete the current level"""
	if _level_completed:
		return

	# Check virtue requirement
	if GameManager and required_virtue > 0:
		if GameManager.virtue_points < required_virtue:
			# Not enough virtue to complete
			_show_message("Need more virtue to proceed!")
			return

	_level_completed = true
	level_completed.emit()

	# Update GameManager
	if GameManager:
		GameManager.level_completed(level_number)

	# Transition to next level or victory screen
	await get_tree().create_timer(1.0).timeout
	_transition_to_next_level()


func _transition_to_next_level() -> void:
	"""Transition to the next level or victory screen"""
	if level_number >= 32:
		# Final level completed - show victory screen
		if SceneManager:
			SceneManager.load_scene(SceneManager.SCENE_VICTORY)
	else:
		# Load next level
		if SceneManager:
			SceneManager.load_level(level_number + 1)


func _on_player_died() -> void:
	"""Called when player dies"""
	level_failed.emit()

	# Wait a moment then reload level or game over
	await get_tree().create_timer(2.0).timeout

	if GameManager:
		if GameManager.lives > 0:
			# Reload current level
			if SceneManager:
				SceneManager.load_level(level_number)
		else:
			# Game over
			if SceneManager:
				SceneManager.load_scene(SceneManager.SCENE_GAME_OVER)


func _on_time_expired() -> void:
	"""Called when time limit expires"""
	if _player:
		_player.take_damage(9999)  # Instant death
	_show_message("Time's up!")


func _show_message(message: String) -> void:
	"""Show a message to the player"""
	print("[Level] ", message)
	# TODO: Show on-screen message when UI is implemented


func reset_level() -> void:
	"""Reset the level to initial state"""
	_level_completed = false
	_start_time = Time.get_ticks_msec() / 1000.0

	if _player:
		_player.reset()
