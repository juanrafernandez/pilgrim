extends CharacterBody2D
class_name NPC

## Base NPC Class
## Non-hostile characters that can interact with the player
## Includes monks, pilgrims, merchants, etc.

# Signals
signal dialogue_started(npc: NPC)
signal dialogue_ended(npc: NPC)
signal quest_given(quest_id: String)
signal item_traded(item_given: String, item_received: String)
signal virtue_awarded(amount: int)

# Enums
enum NPCType {
	MONK,        # Gives blessings/reproof based on Virtue
	PILGRIM,     # Needs help, gives Virtue rewards
	MERCHANT,    # Trades items
	ELDER        # Gives moral riddles
}

enum State {
	IDLE,
	TALKING,
	WAITING,     # Waiting for player action
	GRATEFUL,    # After being helped
	DISAPPOINTED # If player ignores/fails
}

# NPC properties
@export var npc_name: String = "Unknown NPC"
@export var npc_type: NPCType = NPCType.MONK
@export var dialogue_text: String = "Hello, pilgrim."
@export var interaction_range: float = 100.0
@export var can_repeat_interaction: bool = false

# State
var current_state: State = State.IDLE
var has_been_interacted: bool = false
var player_in_range: bool = false
var player_ref: Player = null

# Nodes
@onready var sprite: ColorRect = $Sprite if has_node("Sprite") else null
@onready var interaction_area: Area2D = $InteractionArea if has_node("InteractionArea") else null
@onready var prompt_label: Label = $InteractionPrompt if has_node("InteractionPrompt") else null


func _ready() -> void:
	_setup_interaction_area()
	_setup_visual()
	print("%s (%s) ready" % [npc_name, NPCType.keys()[npc_type]])


func _physics_process(_delta: float) -> void:
	# Check for player interaction input
	if player_in_range and Input.is_action_just_pressed("ui_accept"):  # E key or gamepad button
		interact()


func _setup_interaction_area() -> void:
	"""Setup interaction area for detecting player"""
	if interaction_area:
		interaction_area.body_entered.connect(_on_player_entered_range)
		interaction_area.body_exited.connect(_on_player_exited_range)


func _setup_visual() -> void:
	"""Setup NPC visual appearance based on type"""
	if not sprite:
		return

	match npc_type:
		NPCType.MONK:
			sprite.color = Color(0.4, 0.2, 0.1)  # Brown robes
		NPCType.PILGRIM:
			sprite.color = Color(0.6, 0.6, 0.4)  # Tan clothes
		NPCType.MERCHANT:
			sprite.color = Color(0.8, 0.6, 0.2)  # Gold/yellow
		NPCType.ELDER:
			sprite.color = Color(0.5, 0.5, 0.5)  # Gray robes

	# Hide interaction prompt initially
	if prompt_label:
		prompt_label.visible = false


func interact() -> void:
	"""Player interacts with NPC"""
	if current_state == State.TALKING:
		return  # Already talking

	if has_been_interacted and not can_repeat_interaction:
		_show_repeat_message()
		return

	has_been_interacted = true
	_start_interaction()


func _start_interaction() -> void:
	"""Start NPC interaction"""
	change_state(State.TALKING)
	dialogue_started.emit(self)
	print("%s: %s" % [npc_name, dialogue_text])

	# Type-specific interaction
	match npc_type:
		NPCType.MONK:
			_monk_interaction()
		NPCType.PILGRIM:
			_pilgrim_interaction()
		NPCType.MERCHANT:
			_merchant_interaction()
		NPCType.ELDER:
			_elder_interaction()


func _end_interaction() -> void:
	"""End NPC interaction"""
	change_state(State.IDLE)
	dialogue_ended.emit(self)
	_hide_prompt()


func _monk_interaction() -> void:
	"""Monk evaluates player's Virtue"""
	var virtue_level = GameManager.total_virtue

	if virtue_level >= 500:
		print("%s: Your virtue is exemplary, pilgrim. Receive my blessing." % npc_name)
		GameManager.add_virtue(50)
		virtue_awarded.emit(50)
	elif virtue_level >= 200:
		print("%s: You walk a righteous path. Continue with faith." % npc_name)
		GameManager.add_virtue(20)
		virtue_awarded.emit(20)
	else:
		print("%s: Your virtue wanes, pilgrim. Reflect on your actions." % npc_name)
		# No virtue reward for low virtue

	await get_tree().create_timer(2.0).timeout
	_end_interaction()


func _pilgrim_interaction() -> void:
	"""Pilgrim asks for help"""
	print("%s: Please, help me reach the next sanctuary safely!" % npc_name)
	quest_given.emit("help_pilgrim_%s" % name)

	# For now, automatically complete quest after delay
	await get_tree().create_timer(3.0).timeout
	_pilgrim_helped()


func _pilgrim_helped() -> void:
	"""Pilgrim was successfully helped"""
	change_state(State.GRATEFUL)
	print("%s: Thank you! May God guide your path." % npc_name)
	GameManager.add_virtue(100)
	virtue_awarded.emit(100)

	await get_tree().create_timer(2.0).timeout
	_end_interaction()


func _merchant_interaction() -> void:
	"""Merchant offers trade"""
	print("%s: I have wares to trade, if you have coin." % npc_name)
	# TODO: Implement trading system
	print("(Trading system not yet implemented)")

	await get_tree().create_timer(2.0).timeout
	_end_interaction()


func _elder_interaction() -> void:
	"""Elder poses moral riddle"""
	var riddles = [
		"What is heavier: a knight's armor or his conscience?",
		"Who travels farther: he who walks in circles, or he who stands still in prayer?",
		"What light guides better: the torch in your hand or the faith in your heart?"
	]

	var riddle = riddles[randi() % riddles.size()]
	print("%s: Ponder this, young one: %s" % [npc_name, riddle])

	# TODO: Implement riddle answer system
	print("(Answer choices not yet implemented)")

	await get_tree().create_timer(3.0).timeout
	_end_interaction()


func _show_repeat_message() -> void:
	"""Show message for repeat interaction"""
	print("%s: We have already spoken, pilgrim." % npc_name)


func _show_prompt() -> void:
	"""Show interaction prompt"""
	if prompt_label:
		prompt_label.visible = true
		prompt_label.text = "[E] Talk"


func _hide_prompt() -> void:
	"""Hide interaction prompt"""
	if prompt_label:
		prompt_label.visible = false


func change_state(new_state: State) -> void:
	"""Change NPC state"""
	if current_state == new_state:
		return

	current_state = new_state
	# print("%s: State changed to %s" % [npc_name, State.keys()[new_state]])


## Area detection
func _on_player_entered_range(body: Node2D) -> void:
	"""Player entered interaction range"""
	if body is Player:
		player_in_range = true
		player_ref = body
		_show_prompt()
		print("Player near %s - press E to interact" % npc_name)


func _on_player_exited_range(body: Node2D) -> void:
	"""Player exited interaction range"""
	if body is Player:
		player_in_range = false
		player_ref = null
		_hide_prompt()
