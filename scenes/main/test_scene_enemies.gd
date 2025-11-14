extends Node2D

## Test Scene Enemies
## Test scene for enemy AI and combat system

@onready var player: Player = $Player
@onready var camera: CameraController = $Camera
@onready var enemies_node: Node2D = $Enemies
@onready var death_zone: Area2D = $DeathZone
@onready var arcade_hud = $ArcadeHUD  # Type inferred from scene
@onready var enemy_count_label: Label = $DebugUI/EnemyCountLabel
@onready var debug_label: Label = $DebugUI/DebugLabel

var enemy_count: int = 0
var spawn_position: Vector2 = Vector2(200, 1600)  # Initial spawn point


func _ready() -> void:
	print("Test Scene Enemies loaded")

	# Initialize GameManager for test scene
	GameManager.change_state(GameManager.GameState.PLAYING)

	# Setup camera for player
	player.set_camera_controller(camera)

	# Connect player signals
	player.health_changed.connect(_on_player_health_changed)
	player.died.connect(_on_player_died)
	player.weapon_changed.connect(_on_player_weapon_changed)

	# Connect GameManager signals
	GameManager.lives_changed.connect(_on_lives_changed)
	GameManager.player_respawned.connect(_on_player_respawned)
	GameManager.game_state_changed.connect(_on_game_state_changed)

	# Connect death zone
	death_zone.body_entered.connect(_on_death_zone_entered)

	# Connect to all enemy signals
	_setup_enemy_connections()

	# Count enemies
	_update_enemy_count()

	# Initialize UI
	_update_ui()

	# Improve UI readability
	_setup_ui_backgrounds()


func _physics_process(_delta: float) -> void:
	_update_debug_info()

	# ESC: Return to menu
	if Input.is_action_just_pressed("pause"):
		SceneManager.load_scene("res://scenes/main/main_menu.tscn")


func _setup_enemy_connections() -> void:
	"""Connect to all enemy signals"""
	for enemy in enemies_node.get_children():
		if enemy.has_signal("died"):
			enemy.died.connect(_on_enemy_died.bind(enemy))
		if enemy.has_signal("player_detected"):
			enemy.player_detected.connect(_on_enemy_detected_player.bind(enemy))
		if enemy.has_signal("attacked"):
			enemy.attacked.connect(_on_enemy_attacked.bind(enemy))


func _update_enemy_count() -> void:
	"""Count remaining enemies"""
	enemy_count = 0
	for enemy in enemies_node.get_children():
		if enemy is Enemy and not enemy.is_dead:
			enemy_count += 1

	enemy_count_label.text = "Enemigos: %d" % enemy_count


func _update_ui() -> void:
	"""Update UI elements"""
	arcade_hud.set_health(player.current_health, player.max_health)
	arcade_hud.set_score(0)  # TODO: Implement score system
	arcade_hud.set_lives(GameManager.lives)
	arcade_hud.set_weapon(player.get_weapon_name())


func _update_debug_info() -> void:
	"""Update debug information"""
	var fps = Engine.get_frames_per_second()
	var player_state = player.state_machine.get_state_name() if player.state_machine else "N/A"

	# Count enemies by state
	var idle_count = 0
	var patrol_count = 0
	var chase_count = 0
	var attack_count = 0

	for enemy in enemies_node.get_children():
		if enemy is Enemy and not enemy.is_dead:
			match enemy.current_state:
				Enemy.State.IDLE:
					idle_count += 1
				Enemy.State.PATROL:
					patrol_count += 1
				Enemy.State.CHASE:
					chase_count += 1
				Enemy.State.ATTACK:
					attack_count += 1

	debug_label.text = "FPS: %d | Estado: %s | Enemigos [Idle:%d Patrol:%d Chase:%d Attack:%d]" % [
		fps, player_state, idle_count, patrol_count, chase_count, attack_count
	]


## Signal handlers
func _on_player_health_changed(new_health: int, max_hp: int) -> void:
	arcade_hud.set_health(new_health, max_hp)


func _on_player_died() -> void:
	print("Player died in enemy test scene")


func _on_player_weapon_changed(new_weapon: Player.WeaponType) -> void:
	"""Handle weapon changed from player"""
	arcade_hud.set_weapon(player.get_weapon_name())
	print("Weapon changed to: %s" % player.get_weapon_name())


func _on_death_zone_entered(body: Node2D) -> void:
	"""Handle player falling into death zone"""
	if body == player:
		print("Player fell into the pit!")
		player.die()


func _on_enemy_died(enemy: Enemy) -> void:
	print("Enemy died: %s" % enemy.name)
	_update_enemy_count()

	# Check if all enemies defeated
	if enemy_count == 0:
		print("All enemies defeated!")
		_show_victory_message()


func _on_enemy_detected_player(player_ref: Player, enemy: Enemy) -> void:
	print("%s detected player!" % enemy.name)


func _on_enemy_attacked(target: Node2D, enemy: Enemy) -> void:
	print("%s attacked!" % enemy.name)


func _show_victory_message() -> void:
	"""Show victory message when all enemies defeated"""
	var victory_label = Label.new()
	victory_label.text = "¡TODOS LOS ENEMIGOS DERROTADOS!"
	victory_label.add_theme_font_size_override("font_size", 48)
	victory_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
	victory_label.add_theme_constant_override("outline_size", 4)
	victory_label.modulate = Color(1.0, 1.0, 0.0)
	victory_label.position = Vector2(200, 800)

	add_child(victory_label)

	# Fade out after 3 seconds
	await get_tree().create_timer(3.0).timeout
	var tween = create_tween()
	tween.tween_property(victory_label, "modulate:a", 0.0, 1.0)
	await tween.finished
	victory_label.queue_free()


func _setup_ui_backgrounds() -> void:
	"""Add text outlines for better readability"""
	# Add outline to debug labels
	for label in [enemy_count_label, debug_label]:
		label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
		label.add_theme_constant_override("outline_size", 2)


func _on_lives_changed(new_lives: int) -> void:
	"""Handle lives changed from GameManager"""
	arcade_hud.set_lives(new_lives)
	print("Lives changed: %d" % new_lives)


func _on_player_respawned() -> void:
	"""Handle player respawn from GameManager"""
	player.respawn(spawn_position)
	print("Player respawned at spawn position")


func _on_game_state_changed(new_state: GameManager.GameState) -> void:
	"""Handle game state changes"""
	if new_state == GameManager.GameState.GAME_OVER:
		_show_game_over_screen()


func _show_game_over_screen() -> void:
	"""Show Game Over screen"""
	var game_over_label = Label.new()
	game_over_label.text = "GAME OVER"
	game_over_label.add_theme_font_size_override("font_size", 72)
	game_over_label.add_theme_color_override("font_color", Color(1.0, 0.2, 0.2))
	game_over_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
	game_over_label.add_theme_constant_override("outline_size", 6)
	game_over_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	game_over_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	game_over_label.position = Vector2(0, 800)
	game_over_label.size = Vector2(1080, 200)

	add_child(game_over_label)

	# Animate
	game_over_label.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(game_over_label, "modulate:a", 1.0, 1.0)

	# Wait and return to menu
	await get_tree().create_timer(3.0).timeout
	print("Returning to main menu (or reload scene)")
	# TODO: SceneManager.load_scene("res://scenes/main/main_menu.tscn")
