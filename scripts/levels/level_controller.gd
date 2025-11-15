extends Node2D
class_name LevelController

## Level controller for managing level-specific logic, triggers, and events
## Handles enemy activation, checkpoints, and level progression

signal level_completed
signal checkpoint_reached(checkpoint_id: int)

@export var level_number: int = 1
@export var level_name: String = "Sin nombre"

# Enemy activation management
var _active_enemies: Array[Node] = []
var _inactive_enemies: Array[Node] = []

func _ready() -> void:
	# Find all enemies and set them as inactive initially
	_initialize_enemies()

	# Connect to player signals if needed
	_connect_player_signals()

func _initialize_enemies() -> void:
	"""Initialize all enemies in the level"""
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if enemy.has_method("deactivate"):
			enemy.deactivate()
			_inactive_enemies.append(enemy)

func _connect_player_signals() -> void:
	"""Connect to player signals for level events"""
	var player = get_tree().get_first_node_in_group("player")
	if player:
		# Could connect to player signals here if needed
		pass

func activate_enemy(enemy: Node) -> void:
	"""Activate a specific enemy"""
	if enemy in _inactive_enemies:
		_inactive_enemies.erase(enemy)
		_active_enemies.append(enemy)
		if enemy.has_method("activate"):
			enemy.activate()

func complete_level() -> void:
	"""Called when level is completed"""
	level_completed.emit()
	# SceneManager will handle transition

func _on_enemy_trigger_entered(trigger_area: Area2D, enemy: Node) -> void:
	"""Called when player enters an enemy trigger zone"""
	activate_enemy(enemy)
