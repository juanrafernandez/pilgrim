extends CanvasLayer
class_name CRTEffect

## CRTEffect
## Retro CRT monitor effect with scanlines, curvature, and chromatic aberration
## Toggleable for players who prefer clean graphics

# UI Elements
@onready var scanlines: ColorRect = $Scanlines
@onready var vignette: ColorRect = $Vignette
@onready var noise_overlay: ColorRect = $NoiseOverlay

# Effect settings
var scanlines_enabled: bool = true
var curvature_enabled: bool = false  # More complex, optional
var chromatic_aberration_enabled: bool = false  # Shader-based, optional
var vignette_enabled: bool = true

# Scanline parameters
var scanline_intensity: float = 0.15  # 0.0 to 1.0
var scanline_frequency: float = 2.0   # Lines per pixel

# Vignette parameters
var vignette_intensity: float = 0.3   # 0.0 to 1.0

# Noise parameters
var noise_enabled: bool = false
var noise_intensity: float = 0.05


func _ready() -> void:
	_setup_effects()
	apply_settings()


func _setup_effects() -> void:
	"""Setup visual effect layers"""
	# Scanlines
	if scanlines:
		scanlines.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# Vignette
	if vignette:
		vignette.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# Noise overlay
	if noise_overlay:
		noise_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
		noise_overlay.visible = noise_enabled


func apply_settings() -> void:
	"""Apply current effect settings"""
	_update_scanlines()
	_update_vignette()
	_update_noise()


func _update_scanlines() -> void:
	"""Update scanline effect"""
	if not scanlines:
		return

	scanlines.visible = scanlines_enabled

	if scanlines_enabled:
		# Create scanline pattern (simple horizontal lines)
		# In a real implementation, you'd use a shader for better performance
		scanlines.color = Color(0, 0, 0, scanline_intensity)


func _update_vignette() -> void:
	"""Update vignette effect"""
	if not vignette:
		return

	vignette.visible = vignette_enabled

	if vignette_enabled:
		# Radial gradient from center (darker edges)
		# In production, use a gradient texture or shader
		vignette.color = Color(0, 0, 0, vignette_intensity)


func _update_noise() -> void:
	"""Update noise overlay"""
	if not noise_overlay:
		return

	noise_overlay.visible = noise_enabled

	if noise_enabled:
		# Animated noise (would use shader in production)
		noise_overlay.color = Color(1, 1, 1, noise_intensity)


## Public API

func enable_scanlines(enabled: bool = true) -> void:
	"""Enable/disable scanline effect"""
	scanlines_enabled = enabled
	_update_scanlines()


func enable_vignette(enabled: bool = true) -> void:
	"""Enable/disable vignette effect"""
	vignette_enabled = enabled
	_update_vignette()


func enable_noise(enabled: bool = true) -> void:
	"""Enable/disable noise overlay"""
	noise_enabled = enabled
	_update_noise()


func enable_all_effects(enabled: bool = true) -> void:
	"""Enable/disable all CRT effects"""
	scanlines_enabled = enabled
	vignette_enabled = enabled
	noise_enabled = enabled
	apply_settings()


func set_scanline_intensity(intensity: float) -> void:
	"""Set scanline darkness (0.0 to 1.0)"""
	scanline_intensity = clampf(intensity, 0.0, 1.0)
	_update_scanlines()


func set_vignette_intensity(intensity: float) -> void:
	"""Set vignette darkness (0.0 to 1.0)"""
	vignette_intensity = clampf(intensity, 0.0, 1.0)
	_update_vignette()


func set_noise_intensity(intensity: float) -> void:
	"""Set noise opacity (0.0 to 1.0)"""
	noise_intensity = clampf(intensity, 0.0, 1.0)
	_update_noise()


## Preset modes

func apply_preset_light() -> void:
	"""Light CRT effect preset"""
	scanline_intensity = 0.1
	vignette_intensity = 0.2
	noise_enabled = false
	apply_settings()


func apply_preset_medium() -> void:
	"""Medium CRT effect preset"""
	scanline_intensity = 0.15
	vignette_intensity = 0.3
	noise_enabled = true
	noise_intensity = 0.05
	apply_settings()


func apply_preset_heavy() -> void:
	"""Heavy CRT effect preset"""
	scanline_intensity = 0.25
	vignette_intensity = 0.4
	noise_enabled = true
	noise_intensity = 0.1
	apply_settings()


func apply_preset_off() -> void:
	"""Disable all effects"""
	enable_all_effects(false)
