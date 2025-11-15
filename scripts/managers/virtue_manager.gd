extends Node

## VirtueManager
## Manages Templar virtue system independently following Single Responsibility Principle
## Singleton pattern via autoload

# Signals
signal virtue_changed(current_virtue: int, max_virtue: int)
signal virtue_level_changed(level: VirtueLevel)
signal virtue_achievement(achievement_name: String)

# Enums
enum VirtueLevel {
	FALLEN,      # 0-99: Lost the way
	SEEKER,      # 100-299: Searching
	FAITHFUL,    # 300-599: Walking the path
	RIGHTEOUS,   # 600-899: Living virtuously
	EXEMPLARY    # 900-1000: Saint-like
}

# Virtue configuration
const MAX_VIRTUE: int = 1000
const MIN_VIRTUE: int = 0

# Virtue state
var current_virtue: int = 0
var current_level: VirtueLevel = VirtueLevel.SEEKER


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	print("VirtueManager initialized")


## Public API

func add_virtue(amount: int, reason: String = "") -> void:
	"""Add virtue points"""
	current_virtue = clampi(current_virtue + amount, MIN_VIRTUE, MAX_VIRTUE)
	_check_level_change()
	virtue_changed.emit(current_virtue, MAX_VIRTUE)

	if reason:
		print("Virtue +%d (%s). Total: %d/%d" % [amount, reason, current_virtue, MAX_VIRTUE])
	else:
		print("Virtue +%d. Total: %d/%d" % [amount, current_virtue, MAX_VIRTUE])


func remove_virtue(amount: int, reason: String = "") -> void:
	"""Remove virtue points"""
	current_virtue = maxi(MIN_VIRTUE, current_virtue - amount)
	_check_level_change()
	virtue_changed.emit(current_virtue, MAX_VIRTUE)

	if reason:
		print("Virtue -%d (%s). Total: %d/%d" % [amount, reason, current_virtue, MAX_VIRTUE])
	else:
		print("Virtue -%d. Total: %d/%d" % [amount, current_virtue, MAX_VIRTUE])


func get_virtue() -> int:
	return current_virtue


func get_virtue_level() -> VirtueLevel:
	return current_level


func get_virtue_percentage() -> float:
	return float(current_virtue) / float(MAX_VIRTUE)


func get_level_name() -> String:
	return VirtueLevel.keys()[current_level]


## Private methods

func _check_level_change() -> void:
	"""Check if virtue level has changed"""
	var new_level = _calculate_level()

	if new_level != current_level:
		var old_level = current_level
		current_level = new_level
		virtue_level_changed.emit(current_level)
		print("Virtue Level changed: %s → %s" % [VirtueLevel.keys()[old_level], VirtueLevel.keys()[new_level]])


func _calculate_level() -> VirtueLevel:
	"""Calculate virtue level from current virtue"""
	if current_virtue < 100:
		return VirtueLevel.FALLEN
	elif current_virtue < 300:
		return VirtueLevel.SEEKER
	elif current_virtue < 600:
		return VirtueLevel.FAITHFUL
	elif current_virtue < 900:
		return VirtueLevel.RIGHTEOUS
	else:
		return VirtueLevel.EXEMPLARY
