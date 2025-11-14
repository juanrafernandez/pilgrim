extends PlayerState

## Death State
## Player has died

var death_timer: float = 0.0
var death_duration: float = 2.0


func _state_enter() -> void:
	death_timer = 0.0
	player.velocity = Vector2.ZERO
	print("Player entered Death state")

	# Start fade out
	_fade_out()


func _state_physics_update(delta: float) -> void:
	death_timer += delta

	# Stop all movement
	player.velocity = Vector2.ZERO

	# After death animation, reload level
	if death_timer >= death_duration:
		_reload_level()


func _fade_out() -> void:
	"""Fade out player sprite"""
	var tween = player.create_tween()
	tween.tween_property(player.sprite, "modulate:a", 0.0, death_duration * 0.8)


func _reload_level() -> void:
	"""Reload current scene or go to game over"""
	if GameManager.lives > 0:
		# Reload current level
		SceneManager.reload_current_scene()
	else:
		# Go to game over screen
		SceneManager.load_scene_by_name("game_over")
