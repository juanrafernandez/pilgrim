extends Node2D
class_name DamageNumber

## DamageNumber
## Floating damage number that appears on hit
## Arcade-style with different colors for damage types

# Damage types
enum DamageType {
	NORMAL,      # White
	CRITICAL,    # Yellow
	VIRTUE,      # Gold
	HEALING      # Green
}

# UI
var label: Label

# Animation parameters
var velocity: Vector2 = Vector2(0, -50)  # Float upward
var lifetime: float = 1.0
var fade_start: float = 0.5
var elapsed: float = 0.0

# Visual
var damage_type: DamageType = DamageType.NORMAL

# Type colors
const TYPE_COLORS = {
	DamageType.NORMAL: Color(1.0, 1.0, 1.0),      # White
	DamageType.CRITICAL: Color(1.0, 1.0, 0.2),    # Yellow
	DamageType.VIRTUE: Color(1.0, 0.84, 0.0),     # Gold
	DamageType.HEALING: Color(0.2, 1.0, 0.4)      # Green
}


func _ready() -> void:
	# Create label
	label = Label.new()
	add_child(label)

	# Setup style
	label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
	label.add_theme_constant_override("outline_size", 2)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	# Random horizontal spread
	velocity.x = randf_range(-20, 20)


func _process(delta: float) -> void:
	elapsed += delta

	# Move
	position += velocity * delta

	# Decelerate
	velocity = velocity.lerp(Vector2.ZERO, 2.0 * delta)

	# Fade out
	if elapsed >= fade_start:
		var fade_progress = (elapsed - fade_start) / (lifetime - fade_start)
		modulate.a = 1.0 - fade_progress

	# Destroy when lifetime expired
	if elapsed >= lifetime:
		queue_free()


func setup(damage: int, type: DamageType = DamageType.NORMAL) -> void:
	"""Setup damage number with value and type"""
	damage_type = type

	# Set text
	var prefix = ""
	if type == DamageType.HEALING:
		prefix = "+"
	elif type == DamageType.VIRTUE:
		prefix = "+"

	label.text = "%s%d" % [prefix, abs(damage)]

	# Set color
	if TYPE_COLORS.has(type):
		label.add_theme_color_override("font_color", TYPE_COLORS[type])

	# Set size based on type
	if type == DamageType.CRITICAL:
		label.add_theme_font_size_override("font_size", 24)
		scale = Vector2(1.3, 1.3)
		# Bounce effect for critical
		_bounce_effect()
	elif type == DamageType.VIRTUE:
		label.add_theme_font_size_override("font_size", 20)
		scale = Vector2(1.2, 1.2)
	else:
		label.add_theme_font_size_override("font_size", 18)


func _bounce_effect() -> void:
	"""Bounce animation for critical hits"""
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.3).from(Vector2(1.5, 1.5))
