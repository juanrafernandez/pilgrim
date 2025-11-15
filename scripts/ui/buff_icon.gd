extends Control
class_name BuffIcon

## BuffIcon
## Single buff/power-up indicator with timer ring
## Shows icon and remaining time

# UI Elements
@onready var icon_background: ColorRect = $IconBackground
@onready var icon_label: Label = $IconLabel
@onready var timer_ring: ProgressBar = $TimerRing
@onready var time_label: Label = $TimeLabel

# Buff data
var buff_name: String = ""
var total_duration: float = 0.0
var remaining_time: float = 0.0
var is_active: bool = false

# Visual
var icon_symbol: String = "?"
var buff_color: Color = Color(1.0, 1.0, 1.0)


func _ready() -> void:
	_setup_style()


func _process(delta: float) -> void:
	if is_active and remaining_time > 0.0:
		remaining_time -= delta
		_update_timer_display()

		if remaining_time <= 0.0:
			buff_expired()


func _setup_style() -> void:
	"""Setup visual style"""
	if icon_background:
		icon_background.color = Color(0.2, 0.2, 0.2, 0.8)

	if icon_label:
		icon_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
		icon_label.add_theme_constant_override("outline_size", 2)

	if time_label:
		time_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
		time_label.add_theme_constant_override("outline_size", 1)

	if timer_ring:
		timer_ring.show_percentage = false


func activate_buff(name: String, icon: String, duration: float, color: Color = Color(1.0, 1.0, 1.0)) -> void:
	"""Activate a buff with icon and duration"""
	buff_name = name
	icon_symbol = icon
	total_duration = duration
	remaining_time = duration
	buff_color = color
	is_active = true

	# Set visuals
	if icon_label:
		icon_label.text = icon_symbol
		icon_label.add_theme_color_override("font_color", buff_color)

	if timer_ring:
		timer_ring.max_value = total_duration
		timer_ring.value = remaining_time
		timer_ring.modulate = buff_color

	_update_timer_display()

	# Entry animation
	_play_entry_animation()


func buff_expired() -> void:
	"""Handle buff expiration"""
	is_active = false
	_play_exit_animation()


func extend_duration(additional_time: float) -> void:
	"""Add more time to buff (stacking)"""
	remaining_time += additional_time
	total_duration += additional_time

	if timer_ring:
		timer_ring.max_value = total_duration

	# Pulse effect on extension
	_pulse_effect()


func _update_timer_display() -> void:
	"""Update timer ring and time label"""
	if timer_ring:
		timer_ring.value = remaining_time

		# Color warning when low
		if remaining_time <= 5.0:
			timer_ring.modulate = Color(1.0, 0.3, 0.3)  # Red warning
		else:
			timer_ring.modulate = buff_color

	if time_label:
		time_label.text = "%ds" % int(ceil(remaining_time))


func _play_entry_animation() -> void:
	"""Animation when buff appears"""
	scale = Vector2(0.0, 0.0)
	modulate.a = 0.0

	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)

	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.3)
	tween.parallel().tween_property(self, "modulate:a", 1.0, 0.3)


func _play_exit_animation() -> void:
	"""Animation when buff expires"""
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", Vector2(0.0, 0.0), 0.2)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.2)
	tween.tween_callback(queue_free)


func _pulse_effect() -> void:
	"""Pulse when duration extended"""
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
