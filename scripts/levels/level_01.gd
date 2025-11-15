extends Node2D

## Nivel 1: "El Inicio del Camino"
## Saint-Jean-Pied-de-Port → Roncesvalles
## Nivel tutorial con introducción progresiva de mecánicas

const LEVEL_NUMBER = 1
const LEVEL_NAME = "El Inicio del Camino"

@onready var player = $Player
@onready var camera = $Camera

# Enemy references
@onready var wolf_1 = $Enemies/Wolf1
@onready var wolf_2 = $Enemies/Wolf2
@onready var wolf_3a = $Enemies/Wolf3A
@onready var wolf_3b = $Enemies/Wolf3B
@onready var wolf_4a = $Enemies/Wolf4A
@onready var wolf_4b = $Enemies/Wolf4B

# Trigger references
@onready var trigger_wolf1 = $Triggers/TriggerWolf1
@onready var trigger_wolf2 = $Triggers/TriggerWolf2
@onready var trigger_section3 = $Triggers/TriggerSection3
@onready var trigger_section4 = $Triggers/TriggerSection4
@onready var trigger_end = $Triggers/TriggerEnd

func _ready() -> void:
	# Wait for scene to be fully ready
	await get_tree().process_frame

	# Connect triggers
	_connect_triggers()

	# Deactivate all enemies initially (tutorial level - enemies spawn on trigger)
	_deactivate_all_enemies()

	# Set player phase to Child (Phase 1 - levels 1-8)
	if player and player.has_method("set_phase"):
		player.set_phase(GameManager.PlayerPhase.CHILD)

func _connect_triggers() -> void:
	"""Connect all trigger areas"""
	trigger_wolf1.body_entered.connect(_on_trigger_wolf1_entered)
	trigger_wolf2.body_entered.connect(_on_trigger_wolf2_entered)
	trigger_section3.body_entered.connect(_on_trigger_section3_entered)
	trigger_section4.body_entered.connect(_on_trigger_section4_entered)
	trigger_end.body_entered.connect(_on_trigger_end_entered)

func _deactivate_all_enemies() -> void:
	"""Set all enemies to inactive state"""
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if enemy.has_method("set_active"):
			enemy.set_active(false)

func _activate_enemy(enemy: CharacterBody2D) -> void:
	"""Activate a specific enemy"""
	if enemy and enemy.has_method("set_active"):
		enemy.set_active(true)

# Trigger callbacks
func _on_trigger_wolf1_entered(body: Node2D) -> void:
	"""Section 1: First wolf appears"""
	if body.is_in_group("player"):
		_activate_enemy(wolf_1)
		trigger_wolf1.queue_free()  # Disable trigger

func _on_trigger_wolf2_entered(body: Node2D) -> void:
	"""Section 2: Patrolling wolf"""
	if body.is_in_group("player"):
		_activate_enemy(wolf_2)
		trigger_wolf2.queue_free()

func _on_trigger_section3_entered(body: Node2D) -> void:
	"""Section 3: Two wolves in formation"""
	if body.is_in_group("player"):
		_activate_enemy(wolf_3a)
		# Delay second wolf slightly
		await get_tree().create_timer(0.8).timeout
		_activate_enemy(wolf_3b)
		trigger_section3.queue_free()

func _on_trigger_section4_entered(body: Node2D) -> void:
	"""Section 4: Final challenge - two simultaneous wolves"""
	if body.is_in_group("player"):
		_activate_enemy(wolf_4a)
		_activate_enemy(wolf_4b)
		trigger_section4.queue_free()

func _on_trigger_end_entered(body: Node2D) -> void:
	"""Level complete trigger"""
	if body.is_in_group("player"):
		_complete_level()

func _complete_level() -> void:
	"""Handle level completion"""
	print("¡Nivel 1 completado!")
	# TODO: Show completion screen or transition to next level
	# SceneManager.load_next_level()
