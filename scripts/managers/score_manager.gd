extends Node

## ScoreManager
## Manages player score independently following Single Responsibility Principle
## Singleton pattern via autoload

# Signals
signal score_changed(new_score: int)
signal high_score_beaten(new_high_score: int)

# Score state
var current_score: int = 0
var high_score: int = 0
var score_multiplier: float = 1.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_load_high_score()
	print("ScoreManager initialized - High Score: %d" % high_score)


## Public API

func add_score(points: int, use_multiplier: bool = true) -> void:
	"""Add points to current score"""
	var final_points = int(points * score_multiplier) if use_multiplier else points
	current_score += final_points

	_check_high_score()
	score_changed.emit(current_score)

	if use_multiplier and score_multiplier > 1.0:
		print("Score +%d (x%.1f) = %d points. Total: %d" % [points, score_multiplier, final_points, current_score])
	else:
		print("Score +%d points. Total: %d" % [points, current_score])


func set_multiplier(multiplier: float) -> void:
	"""Set score multiplier (usually from combo system)"""
	score_multiplier = max(1.0, multiplier)


func reset_score() -> void:
	"""Reset current score (for new game/level)"""
	current_score = 0
	score_multiplier = 1.0
	score_changed.emit(current_score)
	print("Score reset")


func get_score() -> int:
	return current_score


func get_high_score() -> int:
	return high_score


## Private methods

func _check_high_score() -> void:
	"""Check if current score beats high score"""
	if current_score > high_score:
		high_score = current_score
		_save_high_score()
		high_score_beaten.emit(high_score)
		print("NEW HIGH SCORE: %d!" % high_score)


func _load_high_score() -> void:
	"""Load high score from file"""
	# TODO: Implement save/load system
	high_score = 0


func _save_high_score() -> void:
	"""Save high score to file"""
	# TODO: Implement save/load system
	pass
