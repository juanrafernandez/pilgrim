extends Control
class_name BossHealthBar

## BossHealthBar
## Dramatic boss health display that appears during boss fights
## Arcade-style with animations

# UI Elements
@onready var boss_container: PanelContainer = $BossContainer
@onready var boss_name_label: Label = $BossContainer/VBox/BossNameLabel
@onready var boss_health_bar: ProgressBar = $BossContainer/VBox/BossHealthBar

# Animation
var is_visible: bool = false
var target_health: float = 100.0
var current_displayed_health: float = 100.0
const ANIMATION_SPEED: float = 3.0

# Boss data
var boss_name: String = ""
var boss_max_health: int = 100


func _ready() -> void:
	_setup_style()
	hide_boss_bar()


func _process(delta: float) -> void:
	if is_visible and abs(current_displayed_health - target_health) > 0.1:
		current_displayed_health = lerp(current_displayed_health, target_health, ANIMATION_SPEED * delta)
		_update_bar_value()


func _setup_style() -> void:
	"""Setup arcade-style appearance"""
	if boss_name_label:
		boss_name_label.add_theme_color_override("font_color", Color(1.0, 0.2, 0.2))  # Red
		boss_name_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
		boss_name_label.add_theme_constant_override("outline_size", 3)

	if boss_health_bar:
		boss_health_bar.show_percentage = false
		boss_health_bar.modulate = Color(1.0, 0.2, 0.2)  # Red for boss


func show_boss_bar(boss_display_name: String, max_health: int) -> void:
	"""Show boss health bar with dramatic entrance animation"""
	boss_name = boss_display_name
	boss_max_health = max_health
	target_health = float(max_health)
	current_displayed_health = float(max_health)

	if boss_name_label:
		boss_name_label.text = "☠ BOSS: %s" % boss_name.to_upper()

	if boss_health_bar:
		boss_health_bar.max_value = float(boss_max_health)
		boss_health_bar.value = current_displayed_health

	# Dramatic entrance animation
	is_visible = true
	if boss_container:
		boss_container.modulate.a = 0.0
		boss_container.visible = true

		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_BACK)

		tween.tween_property(boss_container, "modulate:a", 1.0, 0.5)
		tween.parallel().tween_property(boss_container, "position:y", 0.0, 0.5).from(-50.0)


func hide_boss_bar() -> void:
	"""Hide boss health bar with fade out"""
	is_visible = false

	if boss_container:
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN)
		tween.tween_property(boss_container, "modulate:a", 0.0, 0.3)
		tween.tween_callback(func(): boss_container.visible = false)


func update_boss_health(current_health: int) -> void:
	"""Update boss health with smooth animation"""
	if not is_visible:
		return

	target_health = float(current_health)

	# Flash effect on damage
	if current_health < current_displayed_health:
		_flash_damage()


func _update_bar_value() -> void:
	"""Update progress bar value"""
	if boss_health_bar:
		boss_health_bar.value = current_displayed_health

		# Change color based on health percentage
		var percentage = current_displayed_health / float(boss_max_health)
		if percentage <= 0.25:
			boss_health_bar.modulate = Color(1.0, 0.0, 0.0)  # Bright red (critical)
		elif percentage <= 0.5:
			boss_health_bar.modulate = Color(1.0, 0.4, 0.0)  # Orange (damaged)
		else:
			boss_health_bar.modulate = Color(1.0, 0.2, 0.2)  # Red (normal)


func _flash_damage() -> void:
	"""Flash effect when boss takes damage"""
	if boss_health_bar:
		var tween = create_tween()
		tween.tween_property(boss_health_bar, "modulate", Color(1.5, 1.5, 1.5), 0.1)
		tween.tween_property(boss_health_bar, "modulate", Color(1.0, 0.2, 0.2), 0.1)
