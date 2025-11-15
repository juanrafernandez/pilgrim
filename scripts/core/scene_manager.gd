extends Node

## SceneManager
## Handles scene loading, unloading, and transitions
## Access via: SceneManager (global autoload)

# Signals
signal scene_load_started(scene_path: String)
signal scene_load_finished(scene_path: String)
signal transition_started()
signal transition_finished()

# Scene paths constants
const SCENES = {
	"main_menu": "res://scenes/main/main_menu.tscn",
	"level_select": "res://scenes/main/level_select.tscn",
	"game_over": "res://scenes/ui/game_over.tscn",
	"victory": "res://scenes/ui/victory.tscn",
	"pause": "res://scenes/ui/pause_menu.tscn",
	# Levels will be loaded dynamically: res://scenes/levels/level_XX.tscn
}

# Current scene
var current_scene: Node = null
var is_loading: bool = false

# Transition settings
var transition_duration: float = 0.5
var fade_color: Color = Color.BLACK


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Get initial scene
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

	print("SceneManager initialized with scene: %s" % current_scene.name)


## Load scene by path with fade transition
func load_scene(scene_path: String, use_transition: bool = true) -> void:
	if is_loading:
		print("Scene already loading, please wait")
		return

	if not ResourceLoader.exists(scene_path):
		push_error("Scene not found: %s" % scene_path)
		return

	is_loading = true
	scene_load_started.emit(scene_path)

	if use_transition:
		await _fade_out()

	_change_scene_to(scene_path)

	if use_transition:
		await _fade_in()

	is_loading = false
	scene_load_finished.emit(scene_path)
	print("Scene loaded: %s" % scene_path)


## Load scene by key name
func load_scene_by_name(scene_name: String, use_transition: bool = true) -> void:
	if scene_name in SCENES:
		await load_scene(SCENES[scene_name], use_transition)
	else:
		push_error("Scene name not found: %s" % scene_name)


## Load level by number (1-32)
func load_level(level_number: int, use_transition: bool = true) -> void:
	if level_number < 1 or level_number > 32:
		push_error("Invalid level number: %d (must be 1-32)" % level_number)
		return

	var level_path = "res://scenes/levels/level_%02d.tscn" % level_number
	await load_scene(level_path, use_transition)


## Reload current scene
func reload_current_scene(use_transition: bool = true) -> void:
	if current_scene:
		await load_scene(current_scene.scene_file_path, use_transition)


## Actually change the scene
func _change_scene_to(scene_path: String) -> void:
	# Free current scene
	if current_scene:
		current_scene.queue_free()
		await current_scene.tree_exited

	# Load new scene
	var new_scene = load(scene_path).instantiate()
	current_scene = new_scene

	# Add to tree
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene


## Fade out transition
func _fade_out() -> void:
	transition_started.emit()
	var fade = _create_fade_overlay()
	fade.color = Color(fade_color.r, fade_color.g, fade_color.b, 0.0)

	var tween = create_tween()
	tween.tween_property(fade, "color:a", 1.0, transition_duration)
	await tween.finished


## Fade in transition
func _fade_in() -> void:
	var fade = _get_fade_overlay()
	if not fade:
		transition_finished.emit()
		return

	var tween = create_tween()
	tween.tween_property(fade, "color:a", 0.0, transition_duration)
	await tween.finished

	fade.queue_free()
	transition_finished.emit()


## Create fade overlay
func _create_fade_overlay() -> ColorRect:
	var fade = ColorRect.new()
	fade.name = "SceneFadeOverlay"
	fade.color = fade_color
	fade.anchor_right = 1.0
	fade.anchor_bottom = 1.0
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade.z_index = 100  # On top of everything

	get_tree().root.add_child(fade)
	return fade


## Get existing fade overlay
func _get_fade_overlay() -> ColorRect:
	return get_tree().root.get_node_or_null("SceneFadeOverlay")


## Quick scene changes (for debugging/testing)
func go_to_main_menu() -> void:
	await load_scene_by_name("main_menu")


func go_to_level_select() -> void:
	await load_scene_by_name("level_select")


func go_to_game_over() -> void:
	await load_scene_by_name("game_over")


func go_to_victory() -> void:
	await load_scene_by_name("victory")
