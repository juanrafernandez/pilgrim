extends CanvasLayer
class_name LowHealthWarning

## LowHealthWarning
## Visual warning when player health is critical
## Screen border flash and vignette effect

# UI Elements
@onready var warning_border: ColorRect = $WarningBorder
@onready var vignette: ColorRect = $Vignette

# Warning state
var is_warning_active: bool = false
var pulse_timer: float = 0.0
const PULSE_SPEED: float = 3.0

# Thresholds
const CRITICAL_THRESHOLD: float = 0.25  # 25% health
const WARNING_THRESHOLD: float = 0.5   # 50% health


func _ready() -> void:
	_setup_visuals()
	hide_warning()


func _process(delta: float) -> void:
	if is_warning_active:
		pulse_timer += delta * PULSE_SPEED
		_update_pulse()


func _setup_visuals() -> void:
	"""Setup visual elements"""
	# Warning border (red frame around screen)
	if warning_border:
		warning_border.color = Color(1.0, 0.0, 0.0, 0.0)
		warning_border.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# Vignette (darkened edges)
	if vignette:
		vignette.color = Color(0.0, 0.0, 0.0, 0.0)
		vignette.mouse_filter = Control.MOUSE_FILTER_IGNORE


func update_health_status(current_health: int, max_health: int) -> void:
	"""Update warning based on health percentage"""
	var health_percentage = float(current_health) / float(max_health)

	if health_percentage <= CRITICAL_THRESHOLD:
		show_critical_warning()
	elif health_percentage <= WARNING_THRESHOLD:
		show_low_warning()
	else:
		hide_warning()


func show_critical_warning() -> void:
	"""Show critical health warning (intense)"""
	is_warning_active = true

	if warning_border:
		warning_border.visible = true
	if vignette:
		vignette.visible = true


func show_low_warning() -> void:
	"""Show low health warning (moderate)"""
	is_warning_active = true

	if warning_border:
		warning_border.visible = true
	if vignette:
		vignette.visible = false


func hide_warning() -> void:
	"""Hide all warnings"""
	is_warning_active = false

	if warning_border:
		warning_border.visible = false
	if vignette:
		vignette.visible = false


func _update_pulse() -> void:
	"""Update pulsing effect"""
	var pulse_alpha = (sin(pulse_timer) + 1.0) / 2.0  # 0.0 to 1.0

	# Border pulse
	if warning_border and warning_border.visible:
		# More intense pulse for critical health
		var max_alpha = 0.6 if vignette and vignette.visible else 0.3
		warning_border.color.a = pulse_alpha * max_alpha

	# Vignette pulse (critical only)
	if vignette and vignette.visible:
		vignette.color.a = pulse_alpha * 0.4


func flash_damage() -> void:
	"""Quick flash when taking damage"""
	if not warning_border:
		return

	var tween = create_tween()
	tween.tween_property(warning_border, "color:a", 0.8, 0.1)
	tween.tween_property(warning_border, "color:a", 0.0, 0.2)
