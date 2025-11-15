extends HBoxContainer
class_name ShieldBar

## Shield Energy Bar UI Component
## Displays shield energy with color coding and parry window indicator
## Retro arcade style matching the game's aesthetic

# UI Elements
@onready var shield_label: Label = $ShieldLabel
@onready var energy_bar: ProgressBar = $EnergyBar
@onready var parry_indicator: Label = $ParryIndicator

# Visual settings
const COLOR_HIGH: Color = Color(0.2, 0.8, 1.0)  # Cyan (75-100% energy)
const COLOR_MEDIUM: Color = Color(0.0, 0.6, 1.0)  # Blue (25-75% energy)
const COLOR_LOW: Color = Color(1.0, 0.4, 0.0)  # Orange (0-25% energy)
const COLOR_DEPLETED: Color = Color(0.5, 0.5, 0.5)  # Gray (depleted)
const PARRY_COLOR: Color = Color(1.0, 0.8, 0.0)  # Gold (parry active)

# Animation
var parry_flash_timer: float = 0.0
var parry_flash_visible: bool = true
const PARRY_FLASH_INTERVAL: float = 0.1  # Flash every 0.1s


func _ready() -> void:
	_setup_style()
	if parry_indicator:
		parry_indicator.visible = false


func _process(delta: float) -> void:
	# Animate parry indicator flash
	if parry_indicator and parry_indicator.visible:
		parry_flash_timer += delta
		if parry_flash_timer >= PARRY_FLASH_INTERVAL:
			parry_flash_timer = 0.0
			parry_flash_visible = not parry_flash_visible
			parry_indicator.modulate.a = 1.0 if parry_flash_visible else 0.3


func _setup_style() -> void:
	"""Setup arcade-style appearance"""
	if shield_label:
		shield_label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
		shield_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
		shield_label.add_theme_constant_override("outline_size", 2)

	if parry_indicator:
		parry_indicator.add_theme_color_override("font_color", PARRY_COLOR)
		parry_indicator.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
		parry_indicator.add_theme_constant_override("outline_size", 2)


func set_energy(current: int, maximum: int) -> void:
	"""Update shield energy display"""
	if not energy_bar:
		return

	energy_bar.max_value = maximum
	energy_bar.value = current

	# Color code based on energy percentage
	var percentage = float(current) / float(maximum) if maximum > 0 else 0.0

	if current <= 0:
		energy_bar.modulate = COLOR_DEPLETED
	elif percentage <= 0.25:
		energy_bar.modulate = COLOR_LOW
	elif percentage <= 0.75:
		energy_bar.modulate = COLOR_MEDIUM
	else:
		energy_bar.modulate = COLOR_HIGH


func show_parry_indicator(show: bool) -> void:
	"""Show/hide parry window indicator"""
	if parry_indicator:
		parry_indicator.visible = show
		if show:
			parry_flash_timer = 0.0
			parry_flash_visible = true


func set_blocking(is_blocking: bool) -> void:
	"""Visual feedback when blocking is active"""
	if energy_bar:
		# Add a subtle glow/highlight when blocking
		if is_blocking:
			energy_bar.modulate = energy_bar.modulate.lightened(0.2)
		# Modulate will be reset by set_energy() call


func get_energy_percentage() -> float:
	"""Get current energy as percentage"""
	if energy_bar and energy_bar.max_value > 0:
		return energy_bar.value / energy_bar.max_value
	return 0.0


func shield_depleted() -> void:
	"""Visual feedback when shield breaks"""
	if not energy_bar:
		return

	# Flash red to indicate break
	_flash_bar(Color(1.0, 0.0, 0.0), 0.2)  # Red flash

	# Show DEPLETED text
	if shield_label:
		var original_text = shield_label.text
		shield_label.text = "SHIELD DEPLETED!"
		shield_label.add_theme_color_override("font_color", Color(1.0, 0.3, 0.0))  # Orange

		# Reset after 2 seconds
		await get_tree().create_timer(2.0).timeout
		if shield_label:
			shield_label.text = original_text
			shield_label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))


func shield_recharged() -> void:
	"""Visual feedback when shield recharges from depleted state"""
	if not energy_bar:
		return

	# Flash cyan to indicate restoration
	_flash_bar(Color(0.2, 1.0, 1.0), 0.15)  # Bright cyan flash

	# Brief positive message
	if shield_label:
		var original_text = shield_label.text
		shield_label.text = "SHIELD READY!"
		shield_label.add_theme_color_override("font_color", Color(0.2, 1.0, 0.5))  # Green

		# Reset after 1 second
		await get_tree().create_timer(1.0).timeout
		if shield_label:
			shield_label.text = original_text
			shield_label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))


func _flash_bar(flash_color: Color, duration: float) -> void:
	"""Flash the energy bar with a specific color"""
	if not energy_bar:
		return

	var original_modulate = energy_bar.modulate

	# Flash
	energy_bar.modulate = flash_color
	await get_tree().create_timer(duration).timeout

	# Restore (will be overridden by set_energy() on next update)
	if energy_bar:
		energy_bar.modulate = original_modulate
