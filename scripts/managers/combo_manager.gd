extends Node

## ComboManager
## Manages combo system independently following Single Responsibility Principle
## Singleton pattern via autoload

# Signals
signal combo_changed(combo_count: int, multiplier: float)
signal combo_broken(final_combo: int)

# Combo configuration
const COMBO_TIMEOUT: float = 3.0  # Seconds before combo resets
const COMBO_INCREMENT: float = 0.5  # Multiplier increase per combo hit
const MAX_MULTIPLIER: float = 5.0  # Maximum combo multiplier

# Combo state
var combo_count: int = 0
var combo_multiplier: float = 1.0
var combo_timer: float = 0.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	print("ComboManager initialized")


func _process(delta: float) -> void:
	# Update combo timer
	if combo_count > 0 and combo_timer > 0:
		combo_timer -= delta
		if combo_timer <= 0:
			_break_combo()


## Public API

func add_combo_hit() -> void:
	"""Register a combo hit (enemy killed, successful attack, etc.)"""
	combo_count += 1
	combo_timer = COMBO_TIMEOUT

	# Calculate multiplier (caps at MAX_MULTIPLIER)
	combo_multiplier = min(1.0 + (combo_count - 1) * COMBO_INCREMENT, MAX_MULTIPLIER)

	combo_changed.emit(combo_count, combo_multiplier)

	# Notify ScoreManager of new multiplier
	if has_node("/root/ScoreManager"):
		get_node("/root/ScoreManager").set_multiplier(combo_multiplier)

	if combo_count > 1:
		print("COMBO x%d! Multiplier: %.1fx" % [combo_count, combo_multiplier])


func reset_combo() -> void:
	"""Manually reset combo (for level transitions, etc.)"""
	_break_combo()


func get_combo_count() -> int:
	return combo_count


func get_multiplier() -> float:
	return combo_multiplier


## Private methods

func _break_combo() -> void:
	"""Break the combo"""
	var final_combo = combo_count

	if combo_count > 1:
		print("Combo ended at x%d" % combo_count)
		combo_broken.emit(final_combo)

	combo_count = 0
	combo_multiplier = 1.0
	combo_timer = 0.0

	combo_changed.emit(0, 1.0)

	# Reset ScoreManager multiplier
	if has_node("/root/ScoreManager"):
		get_node("/root/ScoreManager").set_multiplier(1.0)
