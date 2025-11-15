extends Node
class_name ScreenShake

## ScreenShake
## Autoload singleton for screen shake effects
## Can be called from anywhere in the game

# Signals
signal shake_started()
signal shake_finished()

# Shake state
var is_shaking: bool = false
var shake_intensity: float = 0.0
var shake_duration: float = 0.0
var shake_elapsed: float = 0.0

# Shake parameters
var trauma: float = 0.0  # 0.0 to 1.0
var trauma_decay: float = 1.5  # How fast shake decreases

# Camera reference
var camera: Camera2D = null

# Original camera position
var original_offset: Vector2 = Vector2.ZERO

# Shake noise (for randomness)
var noise_seed: int = 0
var shake_frequency: float = 15.0  # Shake oscillations per second


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	randomize()
	noise_seed = randi()


func _process(delta: float) -> void:
	if trauma > 0.0:
		trauma = maxf(trauma - trauma_decay * delta, 0.0)
		_apply_shake(delta)
	elif is_shaking:
		_stop_shake()


func set_camera(cam: Camera2D) -> void:
	"""Set the camera to shake"""
	camera = cam
	if camera:
		original_offset = camera.offset


func add_trauma(amount: float) -> void:
	"""Add trauma to trigger shake (0.0 to 1.0)"""
	trauma = minf(trauma + amount, 1.0)

	if not is_shaking and trauma > 0.0:
		is_shaking = true
		shake_started.emit()


func _apply_shake(delta: float) -> void:
	"""Apply shake to camera"""
	if not camera:
		return

	# Shake amount (squared for more dramatic effect)
	var shake_amount = trauma * trauma

	# Calculate shake offset using pseudo-random noise
	var time = Time.get_ticks_msec() / 1000.0
	var offset_x = _get_noise_value(time * shake_frequency) * shake_amount * 20.0
	var offset_y = _get_noise_value(time * shake_frequency + 1000.0) * shake_amount * 20.0

	camera.offset = original_offset + Vector2(offset_x, offset_y)


func _stop_shake() -> void:
	"""Stop shaking and reset camera"""
	is_shaking = false

	if camera:
		camera.offset = original_offset

	shake_finished.emit()


func _get_noise_value(t: float) -> float:
	"""Generate pseudo-random noise value between -1 and 1"""
	# Simple sine-based noise (in production, use OpenSimplexNoise)
	return sin(t * 13.7 + noise_seed) * 0.5 + cos(t * 8.3 + noise_seed) * 0.5


## Public API - Quick shake presets

func shake_light() -> void:
	"""Light shake (hit, pickup)"""
	add_trauma(0.2)


func shake_medium() -> void:
	"""Medium shake (damage, explosion)"""
	add_trauma(0.4)


func shake_heavy() -> void:
	"""Heavy shake (boss hit, death)"""
	add_trauma(0.6)


func shake_extreme() -> void:
	"""Extreme shake (boss death, level complete)"""
	add_trauma(1.0)


func shake_custom(intensity: float, decay_speed: float = 1.5) -> void:
	"""Custom shake with specific intensity and decay"""
	trauma_decay = decay_speed
	add_trauma(intensity)


func stop() -> void:
	"""Immediately stop all shaking"""
	trauma = 0.0
	_stop_shake()
