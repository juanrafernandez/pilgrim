extends Control
class_name StageIndicator

## StageIndicator
## Displays current stage, level, and location information
## Shows phase of life and Camino de Santiago location

# UI Elements
@onready var stage_label: Label = $VBox/StageLabel
@onready var location_label: Label = $VBox/LocationLabel
@onready var phase_label: Label = $VBox/PhaseLabel

# Stage data
var current_stage: int = 1
var current_level: int = 1
var location_name: String = ""
var phase_name: String = ""

# Phase colors
const PHASE_COLORS = {
	"CHILDHOOD": Color(0.4, 0.8, 1.0),      # Light blue
	"ADOLESCENCE": Color(0.2, 1.0, 0.4),    # Green
	"ADULTHOOD": Color(1.0, 0.8, 0.2),      # Gold
	"OLD AGE": Color(0.8, 0.8, 0.8)         # Silver/gray
}


func _ready() -> void:
	_setup_style()


func _setup_style() -> void:
	"""Setup arcade-style appearance"""
	for label in [stage_label, location_label, phase_label]:
		if label:
			label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
			label.add_theme_constant_override("outline_size", 2)


func set_stage_info(stage: int, level: int, location: String, phase: String) -> void:
	"""Update stage information"""
	current_stage = stage
	current_level = level
	location_name = location
	phase_name = phase

	_update_display()


func set_stage(stage: int, level: int) -> void:
	"""Update stage and level numbers"""
	current_stage = stage
	current_level = level
	_update_stage_label()


func set_location(location: String) -> void:
	"""Update location name"""
	location_name = location
	_update_location_label()


func set_phase(phase: String) -> void:
	"""Update life phase"""
	phase_name = phase
	_update_phase_label()


func _update_display() -> void:
	"""Update all display elements"""
	_update_stage_label()
	_update_location_label()
	_update_phase_label()


func _update_stage_label() -> void:
	"""Update stage/level label"""
	if stage_label:
		stage_label.text = "STAGE %d-%d" % [current_stage, current_level]
		stage_label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))


func _update_location_label() -> void:
	"""Update location label"""
	if location_label:
		if location_name.is_empty():
			location_label.visible = false
		else:
			location_label.visible = true
			location_label.text = location_name.to_upper()
			location_label.add_theme_color_override("font_color", Color(1.0, 0.84, 0.0))  # Gold


func _update_phase_label() -> void:
	"""Update phase label with color coding"""
	if phase_label:
		if phase_name.is_empty():
			phase_label.visible = false
		else:
			phase_label.visible = true
			phase_label.text = "PHASE: %s" % phase_name.to_upper()

			# Apply phase color
			var color = PHASE_COLORS.get(phase_name.to_upper(), Color(1.0, 1.0, 1.0))
			phase_label.add_theme_color_override("font_color", color)


func show_stage_intro(duration: float = 3.0) -> void:
	"""Show stage intro animation (can be called at level start)"""
	# Scale up animation
	var original_scale = scale
	scale = Vector2(0.5, 0.5)
	modulate.a = 0.0

	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)

	tween.tween_property(self, "scale", original_scale, 0.5)
	tween.parallel().tween_property(self, "modulate:a", 1.0, 0.5)

	# Optional: fade out after duration
	if duration > 0:
		tween.tween_interval(duration)
		tween.tween_property(self, "modulate:a", 0.5, 0.3)
