extends Control
class_name VirtueDisplay

## VirtueDisplay
## Visual component showing Virtue level and progress
## Connects to VirtueManager signals for real-time updates

# UI Elements
@onready var virtue_label: Label = $VBox/VirtueLabel
@onready var virtue_bar: ProgressBar = $VBox/VirtueBar

# Animation
var target_virtue: int = 0
var current_displayed_virtue: float = 0.0
const ANIMATION_SPEED: float = 5.0  # Higher = faster animation

# Level colors (matching VirtueManager levels)
const LEVEL_COLORS = {
	VirtueManager.VirtueLevel.FALLEN: Color(1.0, 0.2, 0.2),       # Red
	VirtueManager.VirtueLevel.SEEKER: Color(1.0, 0.6, 0.1),       # Orange
	VirtueManager.VirtueLevel.FAITHFUL: Color(1.0, 1.0, 0.2),     # Yellow
	VirtueManager.VirtueLevel.RIGHTEOUS: Color(0.4, 1.0, 0.4),    # Light green
	VirtueManager.VirtueLevel.EXEMPLARY: Color(1.0, 0.84, 0.0)    # Bright gold
}


func _ready() -> void:
	_setup_style()
	_connect_signals()
	_initialize_display()


func _process(delta: float) -> void:
	# Smooth animation towards target virtue
	if abs(current_displayed_virtue - target_virtue) > 0.1:
		current_displayed_virtue = lerp(current_displayed_virtue, float(target_virtue), ANIMATION_SPEED * delta)
		_update_bar_value()


func _setup_style() -> void:
	"""Setup arcade-style visual appearance"""
	if virtue_label:
		virtue_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
		virtue_label.add_theme_constant_override("outline_size", 2)

	if virtue_bar:
		virtue_bar.max_value = VirtueManager.MAX_VIRTUE
		virtue_bar.show_percentage = false


func _connect_signals() -> void:
	"""Connect to VirtueManager signals"""
	if VirtueManager:
		VirtueManager.virtue_changed.connect(_on_virtue_changed)
		VirtueManager.virtue_level_changed.connect(_on_virtue_level_changed)


func _initialize_display() -> void:
	"""Initialize display with current VirtueManager values"""
	if VirtueManager:
		var current_virtue = VirtueManager.get_virtue()
		var current_level = VirtueManager.get_virtue_level()

		target_virtue = current_virtue
		current_displayed_virtue = float(current_virtue)

		_update_display(current_virtue, current_level)


func _update_display(virtue: int, level: VirtueManager.VirtueLevel) -> void:
	"""Update label and bar with current virtue and level"""
	if virtue_label:
		var level_name = VirtueManager.VirtueLevel.keys()[level]
		virtue_label.text = "VIRTUE: %s (%d/%d)" % [level_name, virtue, VirtueManager.MAX_VIRTUE]

		# Apply level color to label
		if LEVEL_COLORS.has(level):
			virtue_label.add_theme_color_override("font_color", LEVEL_COLORS[level])

	_update_bar_value()
	_update_bar_color(level)


func _update_bar_value() -> void:
	"""Update progress bar value"""
	if virtue_bar:
		virtue_bar.value = current_displayed_virtue


func _update_bar_color(level: VirtueManager.VirtueLevel) -> void:
	"""Update progress bar color based on virtue level"""
	if virtue_bar and LEVEL_COLORS.has(level):
		virtue_bar.modulate = LEVEL_COLORS[level]


func _on_virtue_changed(current_virtue: int, max_virtue: int) -> void:
	"""Handle virtue points change"""
	target_virtue = current_virtue
	var current_level = VirtueManager.get_virtue_level()
	_update_display(current_virtue, current_level)


func _on_virtue_level_changed(level: VirtueManager.VirtueLevel) -> void:
	"""Handle virtue level change with animation"""
	var current_virtue = VirtueManager.get_virtue()
	_update_display(current_virtue, level)

	# Optional: Add visual feedback for level change (flash, pulse, etc.)
	_play_level_change_animation()


func _play_level_change_animation() -> void:
	"""Play animation when virtue level changes"""
	# Create a simple scale pulse animation
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)

	# Pulse the entire display
	tween.tween_property(self, "scale", Vector2(1.15, 1.15), 0.2)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.3)
