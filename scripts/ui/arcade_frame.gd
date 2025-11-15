extends CanvasLayer
class_name ArcadeFrame

## ArcadeFrame
## Decorative arcade cabinet frame with Camino de Santiago theme
## Optional visual element for extra retro feel

# UI Elements
@onready var top_border: ColorRect = $TopBorder
@onready var bottom_border: ColorRect = $BottomBorder
@onready var left_border: ColorRect = $LeftBorder
@onready var right_border: ColorRect = $RightBorder
@onready var corner_tl: ColorRect = $CornerTL
@onready var corner_tr: ColorRect = $CornerTR
@onready var corner_bl: ColorRect = $CornerBL
@onready var corner_br: ColorRect = $CornerBR
@onready var decoration_label: Label = $DecorationLabel

# Frame settings
var frame_enabled: bool = true
var frame_thickness: int = 8
var frame_color: Color = Color(0.2, 0.15, 0.1)  # Dark brown (wood)
var decoration_enabled: bool = true

# Decoration symbols (Camino de Santiago themed)
const DECORATION_SYMBOLS = ["✝", "🐚", "⭐", "✝", "🐚"]  # Cross, Shell, Star


func _ready() -> void:
	_setup_frame()
	apply_settings()


func _setup_frame() -> void:
	"""Setup frame visual elements"""
	if decoration_label:
		decoration_label.add_theme_color_override("font_color", Color(1.0, 0.84, 0.0))  # Gold
		decoration_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
		decoration_label.add_theme_constant_override("outline_size", 2)


func apply_settings() -> void:
	"""Apply current frame settings"""
	_update_frame_visibility()
	_update_frame_style()
	_update_decorations()


func _update_frame_visibility() -> void:
	"""Show/hide frame elements"""
	var borders = [top_border, bottom_border, left_border, right_border]
	var corners = [corner_tl, corner_tr, corner_bl, corner_br]

	for border in borders:
		if border:
			border.visible = frame_enabled

	for corner in corners:
		if corner:
			corner.visible = frame_enabled

	if decoration_label:
		decoration_label.visible = frame_enabled and decoration_enabled


func _update_frame_style() -> void:
	"""Update frame color and thickness"""
	var all_elements = [
		top_border, bottom_border, left_border, right_border,
		corner_tl, corner_tr, corner_bl, corner_br
	]

	for element in all_elements:
		if element:
			element.color = frame_color


func _update_decorations() -> void:
	"""Update decorative symbols"""
	if decoration_label and decoration_enabled:
		# Create decoration text with symbols
		var decoration_text = ""
		for symbol in DECORATION_SYMBOLS:
			decoration_text += symbol + "   "
		decoration_label.text = decoration_text


## Public API

func enable_frame(enabled: bool = true) -> void:
	"""Enable/disable frame"""
	frame_enabled = enabled
	_update_frame_visibility()


func enable_decorations(enabled: bool = true) -> void:
	"""Enable/disable decorative symbols"""
	decoration_enabled = enabled
	_update_decorations()
	_update_frame_visibility()


func set_frame_color(color: Color) -> void:
	"""Set frame color"""
	frame_color = color
	_update_frame_style()


func set_frame_thickness(thickness: int) -> void:
	"""Set frame border thickness"""
	frame_thickness = clampi(thickness, 4, 20)
	# Would need to adjust ColorRect sizes in production


## Preset themes

func apply_theme_wood() -> void:
	"""Wood/brown arcade cabinet theme"""
	frame_color = Color(0.2, 0.15, 0.1)
	apply_settings()


func apply_theme_metal() -> void:
	"""Metal/silver arcade cabinet theme"""
	frame_color = Color(0.3, 0.3, 0.35)
	apply_settings()


func apply_theme_gold() -> void:
	"""Gold/ornate theme (fitting for Camino)"""
	frame_color = Color(0.5, 0.4, 0.1)
	apply_settings()


func apply_theme_off() -> void:
	"""Disable frame"""
	enable_frame(false)
