extends CanvasLayer
class_name ArcadeHUD

## Arcade-style HUD
## Minimal, clean interface inspired by Ghosts 'n Goblins and Maldita Castilla
## Displays score, lives, weapon, and health

# UI Elements - Basic HUD
@onready var score_label: Label = $HUDContainer/VBox/TopRow/ScoreLabel
@onready var high_score_label: Label = $HUDContainer/VBox/TopRow/HighScoreLabel
@onready var lives_container: HBoxContainer = $HUDContainer/VBox/MiddleRow/LivesContainer
@onready var weapon_label: Label = $HUDContainer/VBox/MiddleRow/WeaponLabel
@onready var health_bar: ProgressBar = $HUDContainer/VBox/HealthBar
@onready var weapon_durability_bar: ProgressBar = $HUDContainer/VBox/WeaponDurabilityBar
@onready var combo_label: Label = $HUDContainer/VBox/ComboLabel
@onready var virtue_display: VirtueDisplay = $HUDContainer/VBox/VirtueDisplay

# UI Elements - Enhanced Components
@onready var boss_health_bar: BossHealthBar = $BossHealthBar
@onready var stage_indicator: StageIndicator = $HUDContainer/VBox/TopRow/StageIndicator
@onready var level_timer: LevelTimer = $HUDContainer/VBox/TopRow/LevelTimer
@onready var low_health_warning: LowHealthWarning = $LowHealthWarning

# Data
var current_score: int = 0
var high_score: int = 0
var current_lives: int = 3
var current_weapon: String = "DAGGER"

# Life icon scene (simple ColorRect placeholder)
const LIFE_ICON_SIZE: Vector2 = Vector2(24, 24)


func _ready() -> void:
	_setup_hud_style()
	_update_display()


func _setup_hud_style() -> void:
	"""Setup arcade-style visual appearance"""
	# Apply neon/fluorescent colors and outlines to all labels
	for label in [score_label, high_score_label, weapon_label, combo_label]:
		if label:
			label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))  # White
			label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
			label.add_theme_constant_override("outline_size", 2)

	# Combo label starts hidden
	if combo_label:
		combo_label.visible = false


func set_score(score: int) -> void:
	"""Update player score"""
	current_score = score
	if current_score > high_score:
		high_score = current_score
	_update_score_display()


func add_score(points: int) -> void:
	"""Add points to score"""
	set_score(current_score + points)


func set_lives(lives: int) -> void:
	"""Update player lives"""
	current_lives = lives
	_update_lives_display()


func set_weapon(weapon: String) -> void:
	"""Update current weapon"""
	current_weapon = weapon
	_update_weapon_display()


func set_health(current: int, maximum: int) -> void:
	"""Update health bar"""
	if health_bar:
		health_bar.max_value = maximum
		health_bar.value = current

		# Color code based on health percentage
		var percentage = float(current) / float(maximum)
		if percentage <= 0.25:
			health_bar.modulate = Color(1.0, 0.2, 0.2)  # Red
		elif percentage <= 0.5:
			health_bar.modulate = Color(1.0, 0.6, 0.0)  # Orange
		else:
			health_bar.modulate = Color(0.2, 1.0, 0.2)  # Green (neon)

	# Update low health warning
	if low_health_warning:
		low_health_warning.update_health_status(current, maximum)


func set_weapon_durability(current: int, maximum: int) -> void:
	"""Update weapon durability bar"""
	if weapon_durability_bar:
		weapon_durability_bar.max_value = maximum
		weapon_durability_bar.value = current

		# Color code based on durability percentage
		var percentage = float(current) / float(maximum)
		if percentage <= 0.25:
			weapon_durability_bar.modulate = Color(1.0, 0.2, 0.2)  # Red (almost broken)
		elif percentage <= 0.5:
			weapon_durability_bar.modulate = Color(1.0, 0.6, 0.0)  # Orange (damaged)
		else:
			weapon_durability_bar.modulate = Color(0.4, 0.8, 1.0)  # Cyan (good condition)


func _update_display() -> void:
	"""Update all HUD elements"""
	_update_score_display()
	_update_lives_display()
	_update_weapon_display()


func _update_score_display() -> void:
	"""Update score labels with arcade formatting"""
	if score_label:
		score_label.text = "SCORE %07d" % current_score
	if high_score_label:
		high_score_label.text = "HI %07d" % high_score


func _update_lives_display() -> void:
	"""Update lives display with icons"""
	if not lives_container:
		return

	# Clear existing life icons
	for child in lives_container.get_children():
		child.queue_free()

	# Add life icons (simple colored squares as placeholders)
	for i in range(current_lives):
		var life_icon = ColorRect.new()
		life_icon.custom_minimum_size = LIFE_ICON_SIZE
		life_icon.color = Color(0.2, 1.0, 0.2)  # Neon green
		lives_container.add_child(life_icon)


func _update_weapon_display() -> void:
	"""Update weapon display"""
	if weapon_label:
		weapon_label.text = "WEAPON: %s" % current_weapon


func set_combo(combo_count: int, multiplier: float) -> void:
	"""Update combo display"""
	if not combo_label:
		return

	if combo_count > 1:
		combo_label.visible = true
		combo_label.text = "COMBO x%d  (%.1fx)" % [combo_count, multiplier]

		# Color based on combo level
		if combo_count >= 10:
			combo_label.add_theme_color_override("font_color", Color(1.0, 0.2, 1.0))  # Magenta (epic)
		elif combo_count >= 5:
			combo_label.add_theme_color_override("font_color", Color(1.0, 0.8, 0.0))  # Gold (great)
		else:
			combo_label.add_theme_color_override("font_color", Color(0.2, 1.0, 1.0))  # Cyan (good)
	else:
		combo_label.visible = false


## Enhanced HUD Component Methods

func show_boss_health(boss_name: String, max_health: int) -> void:
	"""Show boss health bar"""
	if boss_health_bar:
		boss_health_bar.show_boss_bar(boss_name, max_health)


func update_boss_health(current_health: int) -> void:
	"""Update boss health"""
	if boss_health_bar:
		boss_health_bar.update_boss_health(current_health)


func hide_boss_health() -> void:
	"""Hide boss health bar"""
	if boss_health_bar:
		boss_health_bar.hide_boss_bar()


func set_stage_info(stage: int, level: int, location: String = "", phase: String = "") -> void:
	"""Set stage/level information"""
	if stage_indicator:
		stage_indicator.set_stage_info(stage, level, location, phase)


func show_stage_intro(duration: float = 3.0) -> void:
	"""Show stage intro animation"""
	if stage_indicator:
		stage_indicator.show_stage_intro(duration)


func start_level_timer(time_limit: float = 0.0) -> void:
	"""Start level timer (0 = count up, >0 = countdown)"""
	if level_timer:
		level_timer.start_timer(time_limit)


func stop_level_timer() -> void:
	"""Stop level timer"""
	if level_timer:
		level_timer.stop_timer()


func get_elapsed_time() -> float:
	"""Get elapsed time from timer"""
	if level_timer:
		return level_timer.get_elapsed_time()
	return 0.0
