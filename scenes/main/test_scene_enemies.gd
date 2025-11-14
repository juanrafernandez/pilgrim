extends Node2D

## Test Scene Enemies
## Test scene for enemy AI and combat system

@onready var player: Player = $Player
@onready var enemies_node: Node2D = $Enemies
@onready var health_bar: ProgressBar = $UI/HealthBar
@onready var health_label: Label = $UI/HealthLabel
@onready var enemy_count_label: Label = $UI/EnemyCountLabel
@onready var debug_label: Label = $UI/DebugLabel

var enemy_count: int = 0


func _ready() -> void:
	print("Test Scene Enemies loaded")

	# Connect player signals
	player.health_changed.connect(_on_player_health_changed)
	player.died.connect(_on_player_died)

	# Connect to all enemy signals
	_setup_enemy_connections()

	# Count enemies
	_update_enemy_count()

	# Initialize UI
	_update_ui()


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
	health_bar.max_value = player.max_health
	health_bar.value = player.current_health
	health_label.text = "Salud: %d/%d" % [player.current_health, player.max_health]


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
	health_bar.value = new_health
	health_label.text = "Salud: %d/%d" % [new_health, max_hp]

	# Color code health bar
	if new_health <= max_hp * 0.25:
		health_bar.modulate = Color(1.0, 0.0, 0.0)  # Red
	elif new_health <= max_hp * 0.5:
		health_bar.modulate = Color(1.0, 0.5, 0.0)  # Orange
	else:
		health_bar.modulate = Color(0.0, 1.0, 0.0)  # Green


func _on_player_died() -> void:
	print("Player died in enemy test scene")


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
	victory_label.modulate = Color(1.0, 1.0, 0.0)
	victory_label.position = Vector2(200, 800)

	add_child(victory_label)

	# Fade out after 3 seconds
	await get_tree().create_timer(3.0).timeout
	var tween = create_tween()
	tween.tween_property(victory_label, "modulate:a", 0.0, 1.0)
	await tween.finished
	victory_label.queue_free()
