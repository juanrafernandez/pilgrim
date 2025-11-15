extends Control
class_name LevelTimer

## LevelTimer
## Countdown timer for levels with time limits
## Color-coded warnings and optional bonus for speed

# Signals
signal time_warning(seconds_remaining: int)
signal time_expired()
signal bonus_achieved(bonus_points: int)

# UI Elements
@onready var timer_label: Label = $TimerLabel

# Timer state
var total_time: float = 0.0  # Total time limit in seconds
var elapsed_time: float = 0.0
var is_active: bool = false
var has_time_limit: bool = false

# Warning thresholds (in seconds)
const WARNING_TIME: float = 30.0
const CRITICAL_TIME: float = 10.0

# Bonus time thresholds (finish under this time for bonus)
var bonus_time: float = 0.0
var bonus_points: int = 0


func _ready() -> void:
	_setup_style()
	visible = false


func _process(delta: float) -> void:
	if not is_active or not has_time_limit:
		return

	elapsed_time += delta
	_update_display()
	_check_warnings()


func _setup_style() -> void:
	"""Setup arcade-style appearance"""
	if timer_label:
		timer_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
		timer_label.add_theme_constant_override("outline_size", 2)


func start_timer(time_limit: float = 0.0) -> void:
	"""Start timer with optional time limit (0 = infinite)"""
	elapsed_time = 0.0
	total_time = time_limit
	has_time_limit = time_limit > 0.0
	is_active = true
	visible = true
	_update_display()


func stop_timer() -> void:
	"""Stop the timer"""
	is_active = false


func pause_timer() -> void:
	"""Pause the timer"""
	is_active = false


func resume_timer() -> void:
	"""Resume the timer"""
	is_active = true


func reset_timer() -> void:
	"""Reset timer to zero"""
	elapsed_time = 0.0
	_update_display()


func get_elapsed_time() -> float:
	"""Get elapsed time in seconds"""
	return elapsed_time


func get_remaining_time() -> float:
	"""Get remaining time in seconds (0 if no limit)"""
	if not has_time_limit:
		return 0.0
	return maxf(0.0, total_time - elapsed_time)


func set_bonus_criteria(time_threshold: float, points: int) -> void:
	"""Set time bonus criteria"""
	bonus_time = time_threshold
	bonus_points = points


func _update_display() -> void:
	"""Update timer display"""
	if not timer_label:
		return

	var display_time: float
	var time_text: String

	if has_time_limit:
		# Countdown mode
		var remaining = get_remaining_time()
		display_time = remaining

		# Check if time expired
		if remaining <= 0.0:
			is_active = false
			time_expired.emit()

		time_text = "TIME: %s" % _format_time(display_time)
	else:
		# Count up mode
		display_time = elapsed_time
		time_text = "TIME: %s" % _format_time(display_time)

	timer_label.text = time_text
	_update_color(display_time)


func _format_time(seconds: float) -> String:
	"""Format time as MM:SS"""
	var mins = int(seconds) / 60
	var secs = int(seconds) % 60
	return "%d:%02d" % [mins, secs]


func _update_color(remaining_time: float) -> void:
	"""Update color based on remaining time"""
	if not has_time_limit or not timer_label:
		# Normal color for count-up
		timer_label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
		return

	if remaining_time <= CRITICAL_TIME:
		# Critical: Red flashing
		timer_label.add_theme_color_override("font_color", Color(1.0, 0.2, 0.2))
		_flash_timer()
	elif remaining_time <= WARNING_TIME:
		# Warning: Yellow
		timer_label.add_theme_color_override("font_color", Color(1.0, 1.0, 0.2))
	else:
		# Normal: White
		timer_label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))


func _check_warnings() -> void:
	"""Check for time warnings"""
	if not has_time_limit:
		return

	var remaining = get_remaining_time()

	# Emit warning signals at specific thresholds
	if remaining == WARNING_TIME or remaining == CRITICAL_TIME:
		time_warning.emit(int(remaining))


func _flash_timer() -> void:
	"""Flash timer when critical"""
	# Simple scale pulse
	if timer_label and not timer_label.has_node("FlashTween"):
		var tween = create_tween()
		tween.set_loops()
		tween.tween_property(timer_label, "scale", Vector2(1.1, 1.1), 0.3)
		tween.tween_property(timer_label, "scale", Vector2(1.0, 1.0), 0.3)


func check_time_bonus() -> int:
	"""Check if player earned time bonus. Returns bonus points."""
	if bonus_time > 0.0 and elapsed_time <= bonus_time:
		bonus_achieved.emit(bonus_points)
		return bonus_points
	return 0
