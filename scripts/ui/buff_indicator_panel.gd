extends Control
class_name BuffIndicatorPanel

## BuffIndicatorPanel
## Manages display of active buffs/power-ups
## Max 5 slots for arcade simplicity

# Preload buff icon scene
const BuffIconScene = preload("res://scenes/ui/buff_icon.tscn")

# UI Elements
@onready var buff_container: HBoxContainer = $BuffContainer

# Configuration
const MAX_BUFFS: int = 5

# Active buffs tracking
var active_buffs: Dictionary = {}  # buff_name -> BuffIcon instance


func _ready() -> void:
	pass


func add_buff(buff_name: String, icon: String, duration: float, color: Color = Color(1.0, 1.0, 1.0)) -> void:
	"""Add or refresh a buff"""
	# If buff already exists, extend duration
	if active_buffs.has(buff_name):
		var existing_buff = active_buffs[buff_name]
		if existing_buff:
			existing_buff.extend_duration(duration)
			return

	# Check max buffs
	if active_buffs.size() >= MAX_BUFFS:
		print("BuffIndicatorPanel: Max buffs reached (%d)" % MAX_BUFFS)
		return

	# Create new buff icon
	var buff_icon = BuffIconScene.instantiate()
	buff_container.add_child(buff_icon)

	buff_icon.activate_buff(buff_name, icon, duration, color)
	active_buffs[buff_name] = buff_icon

	# Connect to expiration (cleanup)
	buff_icon.tree_exited.connect(_on_buff_expired.bind(buff_name))


func remove_buff(buff_name: String) -> void:
	"""Manually remove a buff"""
	if active_buffs.has(buff_name):
		var buff_icon = active_buffs[buff_name]
		if buff_icon:
			buff_icon.buff_expired()
		active_buffs.erase(buff_name)


func clear_all_buffs() -> void:
	"""Remove all active buffs"""
	for buff_name in active_buffs.keys():
		remove_buff(buff_name)


func has_buff(buff_name: String) -> bool:
	"""Check if buff is active"""
	return active_buffs.has(buff_name)


func get_buff_remaining_time(buff_name: String) -> float:
	"""Get remaining time for a buff"""
	if active_buffs.has(buff_name):
		var buff_icon = active_buffs[buff_name]
		if buff_icon:
			return buff_icon.remaining_time
	return 0.0


func _on_buff_expired(buff_name: String) -> void:
	"""Cleanup when buff expires"""
	active_buffs.erase(buff_name)


## Predefined buff types (can be called directly)

func add_shield_buff(duration: float = 30.0) -> void:
	"""Add shield/protection buff"""
	add_buff("SHIELD", "🛡", duration, Color(0.4, 0.8, 1.0))  # Blue


func add_damage_buff(duration: float = 20.0) -> void:
	"""Add damage boost buff"""
	add_buff("DAMAGE", "⚔", duration, Color(1.0, 0.3, 0.3))  # Red


func add_speed_buff(duration: float = 15.0) -> void:
	"""Add speed boost buff"""
	add_buff("SPEED", "⚡", duration, Color(1.0, 1.0, 0.2))  # Yellow


func add_healing_buff(duration: float = 45.0) -> void:
	"""Add healing over time buff"""
	add_buff("HEALING", "✚", duration, Color(0.2, 1.0, 0.4))  # Green


func add_virtue_buff(duration: float = 60.0) -> void:
	"""Add divine blessing/virtue buff"""
	add_buff("DIVINE", "✨", duration, Color(1.0, 0.84, 0.0))  # Gold


func add_oil_buff(duration: float = 60.0) -> void:
	"""Add weapon oil buff (reduces degradation)"""
	add_buff("OIL", "🛢", duration, Color(0.6, 0.4, 0.2))  # Brown
