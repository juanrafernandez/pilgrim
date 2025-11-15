extends Node

## GameManager
## Singleton that manages global game state, progression, and systems coordination
## Access via: GameManager (global autoload)

# Signals
signal game_state_changed(new_state: GameState)
signal player_phase_changed(new_phase: PlayerPhase)
signal virtue_changed(new_virtue: int)
signal level_completed(level_id: int, virtue_earned: int)
signal lives_changed(new_lives: int)
signal player_respawned()

# Enums
enum GameState {
	MAIN_MENU,
	PLAYING,
	PAUSED,
	LEVEL_TRANSITION,
	GAME_OVER,
	VICTORY
}

enum PlayerPhase {
	CHILD,        # Levels 1-8: Niño
	ADOLESCENT,   # Levels 9-16: Adolescente
	KNIGHT,       # Levels 17-24: Caballero Templario
	ELDER         # Levels 25-32: Anciano (camino inverso)
}

# Constants
const LEVELS_PER_PHASE: int = 8
const TOTAL_LEVELS: int = 32
const MAX_VIRTUE: int = 1000

# Game state
var current_state: GameState = GameState.MAIN_MENU
var current_phase: PlayerPhase = PlayerPhase.CHILD
var current_level: int = 1
var total_virtue: int = 0
var lives: int = 3

# Player stats
var player_max_health: int = 100
var player_current_health: int = 100

# Level progress tracking
var levels_completed: Array[int] = []
var virtue_per_level: Dictionary = {}  # level_id: virtue_earned

# Settings
var master_volume: float = 1.0
var music_volume: float = 0.8
var sfx_volume: float = 1.0

# Hitstop/Freeze frames
var is_hitstop_active: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS  # Continue running when paused
	_initialize_game()
	print("GameManager initialized")


func _initialize_game() -> void:
	"""Initialize or reset game state"""
	current_state = GameState.MAIN_MENU
	current_phase = PlayerPhase.CHILD
	current_level = 1
	total_virtue = 0
	lives = 3
	player_current_health = player_max_health
	levels_completed.clear()
	virtue_per_level.clear()


## Start a new game
func start_new_game() -> void:
	_initialize_game()
	change_state(GameState.PLAYING)
	print("New game started")


## Load game from save
func load_game() -> bool:
	# Will be implemented with SaveManager
	print("Load game - not yet implemented")
	return false


## Change game state
func change_state(new_state: GameState) -> void:
	if current_state == new_state:
		return

	var old_state = current_state
	current_state = new_state
	game_state_changed.emit(new_state)

	print("Game state changed: %s -> %s" % [GameState.keys()[old_state], GameState.keys()[new_state]])

	# Handle state-specific logic
	match new_state:
		GameState.PAUSED:
			get_tree().paused = true
		GameState.PLAYING:
			get_tree().paused = false
		GameState.GAME_OVER:
			_handle_game_over()
		GameState.VICTORY:
			_handle_victory()


## Pause game
func pause_game() -> void:
	if current_state == GameState.PLAYING:
		change_state(GameState.PAUSED)


## Resume game
func resume_game() -> void:
	if current_state == GameState.PAUSED:
		change_state(GameState.PLAYING)


## Add virtue points
func add_virtue(amount: int) -> void:
	total_virtue = clampi(total_virtue + amount, 0, MAX_VIRTUE)
	virtue_changed.emit(total_virtue)
	print("Virtue added: +%d (Total: %d)" % [amount, total_virtue])


## Remove virtue points
func remove_virtue(amount: int) -> void:
	total_virtue = maxi(0, total_virtue - amount)
	virtue_changed.emit(total_virtue)
	print("Virtue removed: -%d (Total: %d)" % [amount, total_virtue])


## Complete current level
func complete_level(virtue_earned: int) -> void:
	if current_level in levels_completed:
		print("Level %d already completed" % current_level)
		return

	levels_completed.append(current_level)
	virtue_per_level[current_level] = virtue_earned
	add_virtue(virtue_earned)

	level_completed.emit(current_level, virtue_earned)
	print("Level %d completed! Virtue earned: %d" % [current_level, virtue_earned])

	_check_phase_transition()


## Check if we need to transition to next phase
func _check_phase_transition() -> void:
	var new_phase = _calculate_phase_from_level(current_level + 1)
	if new_phase != current_phase:
		change_phase(new_phase)


## Calculate which phase a level belongs to
func _calculate_phase_from_level(level: int) -> PlayerPhase:
	if level <= 8:
		return PlayerPhase.CHILD
	elif level <= 16:
		return PlayerPhase.ADOLESCENT
	elif level <= 24:
		return PlayerPhase.KNIGHT
	else:
		return PlayerPhase.ELDER


## Change player phase
func change_phase(new_phase: PlayerPhase) -> void:
	if current_phase == new_phase:
		return

	var old_phase = current_phase
	current_phase = new_phase
	player_phase_changed.emit(new_phase)

	print("Player phase changed: %s -> %s" % [PlayerPhase.keys()[old_phase], PlayerPhase.keys()[new_phase]])


## Load next level
func load_next_level() -> void:
	if current_level >= TOTAL_LEVELS:
		change_state(GameState.VICTORY)
		return

	current_level += 1
	change_state(GameState.LEVEL_TRANSITION)

	# SceneManager will handle actual scene loading
	print("Loading level %d" % current_level)


## Restart current level
func restart_level() -> void:
	player_current_health = player_max_health
	player_respawned.emit()
	print("Restarting level %d" % current_level)


## Player died
func player_died() -> void:
	lives -= 1
	lives_changed.emit(lives)
	print("Player died! Lives remaining: %d" % lives)

	if lives <= 0:
		change_state(GameState.GAME_OVER)
	else:
		# Wait a moment before respawning
		await get_tree().create_timer(1.0).timeout
		restart_level()


func _handle_game_over() -> void:
	print("GAME OVER - Lives: %d" % lives)
	# Will show game over screen


func _handle_victory() -> void:
	print("VICTORY! All %d levels completed. Total Virtue: %d" % [TOTAL_LEVELS, total_virtue])
	# Will show victory screen


## Get current phase as string
func get_current_phase_name() -> String:
	return PlayerPhase.keys()[current_phase]


## Check if level is unlocked
func is_level_unlocked(level_id: int) -> bool:
	if level_id == 1:
		return true
	return (level_id - 1) in levels_completed


## Get progress percentage
func get_completion_percentage() -> float:
	return (float(levels_completed.size()) / float(TOTAL_LEVELS)) * 100.0


## Apply hitstop/freeze frame effect
func apply_hitstop(duration: float = 0.08) -> void:
	"""Freeze the game briefly for impact feedback (duration in seconds)"""
	if is_hitstop_active:
		return  # Don't stack hitstops

	is_hitstop_active = true
	Engine.time_scale = 0.0  # Freeze time

	# Wait for duration (uses unscaled time so it works even when frozen)
	await get_tree().create_timer(duration, true, false, true).timeout

	Engine.time_scale = 1.0  # Resume normal time
	is_hitstop_active = false
