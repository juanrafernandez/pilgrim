extends Control
class_name ComboMeter

## ComboMeter
## Visual combo meter with progress bar and milestone indicators
## Enhances the basic combo label with visual feedback

# Signals
signal combo_milestone_reached(milestone: int)

# UI Elements
@onready var combo_label: Label = $VBox/ComboLabel
@onready var combo_bar: ProgressBar = $VBox/ComboBar
@onready var milestone_container: HBoxContainer = $VBox/MilestoneContainer

# Combo state
var current_combo: int = 0
var combo_timeout: float = 0.0
var time_since_last_hit: float = 0.0

# Configuration
const COMBO_TIMEOUT: float = 2.0  # Seconds before combo resets
const COMBO_BAR_MAX: float = 100.0  # Visual max for bar

# Milestones
const MILESTONES: Array[int] = [5, 10, 15, 20, 25, 30]
var reached_milestones: Dictionary = {}  # milestone -> bool

# Colors by combo level
const COMBO_COLORS = {
	0: Color(0.5, 0.5, 0.5),        # Gray (no combo)
	2: Color(0.2, 1.0, 1.0),        # Cyan (starting)
	5: Color(1.0, 0.8, 0.0),        # Gold (good)
	10: Color(1.0, 0.2, 1.0),       # Magenta (great)
	15: Color(1.0, 0.2, 0.2),       # Red (amazing)
	20: Color(1.0, 1.0, 1.0)        # White (legendary)
}


func _ready() -> void:
	_setup_style()
	_create_milestone_markers()
	reset_combo()


func _process(delta: float) -> void:
	if current_combo > 0:
		time_since_last_hit += delta

		# Update timeout bar
		var remaining = COMBO_TIMEOUT - time_since_last_hit
		if combo_bar:
			combo_bar.value = (remaining / COMBO_TIMEOUT) * COMBO_BAR_MAX

		# Check timeout
		if time_since_last_hit >= COMBO_TIMEOUT:
			reset_combo()


func _setup_style() -> void:
	"""Setup visual style"""
	if combo_label:
		combo_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
		combo_label.add_theme_constant_override("outline_size", 3)

	if combo_bar:
		combo_bar.show_percentage = false
		combo_bar.max_value = COMBO_BAR_MAX


func _create_milestone_markers() -> void:
	"""Create visual milestone markers"""
	if not milestone_container:
		return

	for milestone in MILESTONES:
		var marker = ColorRect.new()
		marker.custom_minimum_size = Vector2(8, 8)
		marker.color = Color(0.3, 0.3, 0.3, 0.5)  # Inactive gray
		milestone_container.add_child(marker)
		reached_milestones[milestone] = false


func increment_combo(combo_count: int, multiplier: float = 1.0) -> void:
	"""Increment combo counter"""
	current_combo = combo_count
	time_since_last_hit = 0.0

	_update_display()
	_check_milestones()

	# Flash effect on increment
	_flash_effect()


func reset_combo() -> void:
	"""Reset combo to zero"""
	current_combo = 0
	time_since_last_hit = 0.0
	reached_milestones.clear()

	for milestone in MILESTONES:
		reached_milestones[milestone] = false

	_update_display()
	_reset_milestone_markers()

	# Hide when no combo
	visible = false


func _update_display() -> void:
	"""Update visual display"""
	if current_combo <= 0:
		visible = false
		return

	visible = true

	# Update label
	if combo_label:
		combo_label.text = "COMBO x%d" % current_combo

		# Get color for current combo level
		var color = _get_combo_color()
		combo_label.add_theme_color_override("font_color", color)

	# Update bar color
	if combo_bar:
		combo_bar.modulate = _get_combo_color()


func _get_combo_color() -> Color:
	"""Get color based on combo count"""
	var color = COMBO_COLORS[0]  # Default

	# Find highest reached tier
	for threshold in [20, 15, 10, 5, 2, 0]:
		if current_combo >= threshold and COMBO_COLORS.has(threshold):
			color = COMBO_COLORS[threshold]
			break

	return color


func _check_milestones() -> void:
	"""Check if any milestones reached"""
	for milestone in MILESTONES:
		if current_combo >= milestone and not reached_milestones[milestone]:
			reached_milestones[milestone] = true
			_activate_milestone_marker(milestone)
			_trigger_milestone_effect(milestone)
			combo_milestone_reached.emit(milestone)


func _activate_milestone_marker(milestone: int) -> void:
	"""Activate a milestone marker visually"""
	if not milestone_container:
		return

	var index = MILESTONES.find(milestone)
	if index >= 0 and index < milestone_container.get_child_count():
		var marker = milestone_container.get_child(index)
		if marker is ColorRect:
			marker.color = _get_combo_color()
			# Pulse animation
			_pulse_marker(marker)


func _reset_milestone_markers() -> void:
	"""Reset all milestone markers"""
	if not milestone_container:
		return

	for child in milestone_container.get_children():
		if child is ColorRect:
			child.color = Color(0.3, 0.3, 0.3, 0.5)


func _trigger_milestone_effect(milestone: int) -> void:
	"""Trigger special effect for milestone"""
	# Scale pulse
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)

	tween.tween_property(self, "scale", Vector2(1.3, 1.3), 0.2)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.3)

	print("Combo milestone reached: x%d!" % milestone)


func _flash_effect() -> void:
	"""Flash effect on combo increment"""
	if combo_label:
		var tween = create_tween()
		tween.tween_property(combo_label, "modulate", Color(2.0, 2.0, 2.0), 0.05)
		tween.tween_property(combo_label, "modulate", Color(1.0, 1.0, 1.0), 0.1)


func _pulse_marker(marker: Node) -> void:
	"""Pulse animation for milestone marker"""
	var tween = create_tween()
	tween.tween_property(marker, "scale", Vector2(1.5, 1.5), 0.2)
	tween.tween_property(marker, "scale", Vector2(1.0, 1.0), 0.2)
