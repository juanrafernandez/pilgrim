extends CanvasLayer
class_name LevelCompleteScreen

## LevelCompleteScreen
## Arcade-style level complete summary with stats and ranking
## Shows score, virtue, combos, time, and assigns a grade

# Signals
signal continue_pressed()

# UI Elements
@onready var screen_container: PanelContainer = $ScreenContainer
@onready var title_label: Label = $ScreenContainer/VBox/TitleLabel
@onready var stats_container: VBoxContainer = $ScreenContainer/VBox/StatsContainer
@onready var score_label: Label = $ScreenContainer/VBox/StatsContainer/ScoreLabel
@onready var virtue_label: Label = $ScreenContainer/VBox/StatsContainer/VirtueLabel
@onready var combo_label: Label = $ScreenContainer/VBox/StatsContainer/ComboLabel
@onready var time_label: Label = $ScreenContainer/VBox/StatsContainer/TimeLabel
@onready var rank_label: Label = $ScreenContainer/VBox/RankLabel
@onready var continue_label: Label = $ScreenContainer/VBox/ContinueLabel

# Stats
var level_number: int = 1
var score_gained: int = 0
var virtue_gained: int = 0
var max_combo: int = 0
var time_seconds: float = 0.0
var rank: String = "C"

# Ranking thresholds
const RANK_S_SCORE: int = 5000
const RANK_A_SCORE: int = 3000
const RANK_B_SCORE: int = 1500
const RANK_C_SCORE: int = 500

# Rank colors
const RANK_COLORS = {
	"S": Color(1.0, 0.84, 0.0),    # Gold
	"A": Color(0.2, 1.0, 0.2),     # Green
	"B": Color(0.2, 0.8, 1.0),     # Blue
	"C": Color(1.0, 0.6, 0.0),     # Orange
	"D": Color(1.0, 0.2, 0.2)      # Red
}


func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS


func _input(event: InputEvent) -> void:
	if not visible:
		return

	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_select"):
		hide_screen()
		continue_pressed.emit()
		get_viewport().set_input_as_handled()


func show_screen(level: int, score: int, virtue: int, combo: int, time: float) -> void:
	"""Show level complete screen with stats"""
	level_number = level
	score_gained = score
	virtue_gained = virtue
	max_combo = combo
	time_seconds = time

	_calculate_rank()
	_update_display()

	visible = true
	get_tree().paused = true

	# Entry animation
	_play_entry_animation()


func hide_screen() -> void:
	"""Hide screen and resume game"""
	visible = false
	get_tree().paused = false


func _calculate_rank() -> void:
	"""Calculate performance rank based on score"""
	if score_gained >= RANK_S_SCORE:
		rank = "S"
	elif score_gained >= RANK_A_SCORE:
		rank = "A"
	elif score_gained >= RANK_B_SCORE:
		rank = "B"
	elif score_gained >= RANK_C_SCORE:
		rank = "C"
	else:
		rank = "D"


func _update_display() -> void:
	"""Update all display elements"""
	# Title
	if title_label:
		title_label.text = "LEVEL %d COMPLETE!" % level_number

	# Score
	if score_label:
		score_label.text = "SCORE:         +%d" % score_gained

	# Virtue
	if virtue_label:
		virtue_label.text = "VIRTUE:        +%d" % virtue_gained

	# Combo
	if combo_label:
		combo_label.text = "MAX COMBO:     x%d" % max_combo

	# Time
	if time_label:
		var mins = int(time_seconds) / 60
		var secs = int(time_seconds) % 60
		time_label.text = "TIME:          %d:%02d" % [mins, secs]

	# Rank
	if rank_label:
		rank_label.text = "RANK: %s" % rank
		if RANK_COLORS.has(rank):
			rank_label.add_theme_color_override("font_color", RANK_COLORS[rank])


func _play_entry_animation() -> void:
	"""Animate screen entrance"""
	if screen_container:
		screen_container.modulate.a = 0.0
		screen_container.scale = Vector2(0.5, 0.5)

		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_BACK)

		tween.tween_property(screen_container, "modulate:a", 1.0, 0.4)
		tween.parallel().tween_property(screen_container, "scale", Vector2(1.0, 1.0), 0.4)

		# Animate stats one by one
		tween.tween_callback(_animate_stats)


func _animate_stats() -> void:
	"""Animate stats appearing one by one"""
	var stats = [score_label, virtue_label, combo_label, time_label]
	var delay = 0.0

	for stat in stats:
		if stat:
			stat.modulate.a = 0.0

			var tween = create_tween()
			tween.tween_interval(delay)
			tween.tween_property(stat, "modulate:a", 1.0, 0.2)

			delay += 0.15

	# Show rank with extra flair
	if rank_label:
		rank_label.modulate.a = 0.0
		rank_label.scale = Vector2(0.0, 0.0)

		var tween = create_tween()
		tween.tween_interval(delay + 0.2)
		tween.tween_property(rank_label, "modulate:a", 1.0, 0.3)
		tween.parallel().tween_property(rank_label, "scale", Vector2(1.5, 1.5), 0.3)
		tween.tween_property(rank_label, "scale", Vector2(1.0, 1.0), 0.2)

	# Show continue prompt
	if continue_label:
		continue_label.modulate.a = 0.0

		var tween = create_tween()
		tween.tween_interval(delay + 0.8)
		tween.tween_property(continue_label, "modulate:a", 1.0, 0.3)

		# Pulse continue text
		_pulse_continue_label()


func _pulse_continue_label() -> void:
	"""Pulse the continue label"""
	if not continue_label:
		return

	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(continue_label, "modulate:a", 0.3, 0.8)
	tween.tween_property(continue_label, "modulate:a", 1.0, 0.8)
