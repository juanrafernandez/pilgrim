extends Node2D

## Level 01 Script
## Handles level logic, enemy management, and UI updates

@onready var player: Player = $Player
@onready var camera: CameraController = $Camera
@onready var enemies_node: Node2D = $Enemies
@onready var death_zone: Area2D = $DeathZone
@onready var arcade_hud = $ArcadeHUD  # Type inferred from scene

var enemy_count: int = 0


func _ready() -> void:
	print("Level 01 loaded")

	# Initialize GameManager for level
	GameManager.change_state(GameManager.GameState.PLAYING)

	# Setup camera for player
	player.set_camera_controller(camera)

	# Connect player signals
	player.health_changed.connect(_on_player_health_changed)
	player.died.connect(_on_player_died)
	player.weapon_changed.connect(_on_player_weapon_changed)
	player.weapon_durability_changed.connect(_on_weapon_durability_changed)

	# Connect GameManager signals
	GameManager.lives_changed.connect(_on_lives_changed)
	GameManager.player_respawned.connect(_on_player_respawned)
	GameManager.game_state_changed.connect(_on_game_state_changed)

	# Connect specialized manager signals (SOLID - using separate managers)
	if has_node("/root/ScoreManager"):
		get_node("/root/ScoreManager").score_changed.connect(_on_score_changed)

	if has_node("/root/ComboManager"):
		get_node("/root/ComboManager").combo_changed.connect(_on_combo_changed)

	# Connect death zone
	death_zone.body_entered.connect(_on_death_zone_entered)

	# Connect to all enemy signals
	_setup_enemy_connections()

	# Enemies start visible and patrolling (no trigger activation)
	_activate_all_enemies()

	# Count enemies
	_update_enemy_count()

	# Initialize UI
	_update_ui()


func _physics_process(_delta: float) -> void:
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


func _activate_all_enemies() -> void:
	"""Activate all enemies to start patrolling from level start"""
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if enemy.has_method("set_active"):
			enemy.set_active(true)
	print("All enemies activated and patrolling")


func _update_enemy_count() -> void:
	"""Count remaining enemies"""
	enemy_count = 0
	for enemy in enemies_node.get_children():
		if enemy is Enemy and not enemy.is_dead:
			enemy_count += 1

	print("Enemies remaining: %d" % enemy_count)


func _update_ui() -> void:
	"""Update UI elements"""
	arcade_hud.set_health(player.current_health, player.max_health)

	# Get score from ScoreManager (SOLID - accessing specialized manager)
	var current_score = 0
	if has_node("/root/ScoreManager"):
		current_score = get_node("/root/ScoreManager").get_score()
	arcade_hud.set_score(current_score)

	arcade_hud.set_lives(GameManager.lives)
	arcade_hud.set_weapon(player.get_weapon_name())

	# Update weapon durability if weapon is equipped
	if player.equipped_weapon:
		arcade_hud.set_weapon_durability(player.equipped_weapon.current_durability, player.equipped_weapon.max_durability)


## Signal handlers
func _on_player_health_changed(new_health: int, max_hp: int) -> void:
	arcade_hud.set_health(new_health, max_hp)


func _on_player_died() -> void:
	print("Player died in level 01")


func _on_player_weapon_changed(new_weapon) -> void:  # Weapon type (untyped to avoid dependency issues)
	"""Handle weapon changed from player"""
	arcade_hud.set_weapon(player.get_weapon_name())
	if new_weapon:
		arcade_hud.set_weapon_durability(new_weapon.current_durability, new_weapon.max_durability)
	print("Weapon changed to: %s" % player.get_weapon_name())


func _on_weapon_durability_changed(current: int, maximum: int) -> void:
	"""Handle weapon durability changed"""
	arcade_hud.set_weapon_durability(current, maximum)


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


func _on_lives_changed(new_lives: int) -> void:
	"""Handle lives changed from GameManager"""
	arcade_hud.set_lives(new_lives)
	print("Lives changed: %d" % new_lives)


func _on_player_respawned() -> void:
	"""Handle player respawn from GameManager"""
	player.respawn()  # Use auto checkpoint (last safe ground position)
	print("Player respawned at last safe position")


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
	print("Returning to main menu")
	SceneManager.load_scene("res://scenes/main/main_menu.tscn")


func _on_score_changed(new_score: int) -> void:
	"""Handle score changed from ScoreManager"""
	arcade_hud.set_score(new_score)


func _on_combo_changed(combo_count: int, multiplier: float) -> void:
	"""Handle combo changed from ComboManager"""
	arcade_hud.set_combo(combo_count, multiplier)
