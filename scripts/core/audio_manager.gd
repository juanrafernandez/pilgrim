extends Node

## AudioManager
## Manages music and sound effects playback
## Access via: AudioManager (global autoload)

# Signals
signal music_changed(track_name: String)
signal volume_changed(bus_name: String, volume: float)

# Audio buses
const BUS_MASTER = "Master"
const BUS_MUSIC = "Music"
const BUS_SFX = "SFX"

# Audio players
var music_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []
const MAX_SFX_PLAYERS: int = 16  # Pool of SFX players

# Current state
var current_music: String = ""
var music_volume: float = 0.8
var sfx_volume: float = 1.0
var master_volume: float = 1.0

# Music tracks (paths to be filled as audio assets are added)
var music_tracks: Dictionary = {
	"main_menu": "res://assets/audio/music/main_menu.ogg",
	"phase_1": "res://assets/audio/music/phase_1_childhood.ogg",
	"phase_2": "res://assets/audio/music/phase_2_adolescence.ogg",
	"phase_3": "res://assets/audio/music/phase_3_knight.ogg",
	"phase_4": "res://assets/audio/music/phase_4_elder.ogg",
	"combat": "res://assets/audio/music/combat.ogg",
	"victory": "res://assets/audio/music/victory.ogg",
	"game_over": "res://assets/audio/music/game_over.ogg",
}

# SFX library (paths to be filled as audio assets are added)
var sfx_library: Dictionary = {
	# Player
	"footstep": "res://assets/audio/sfx/footstep.ogg",
	"jump": "res://assets/audio/sfx/jump.ogg",
	"land": "res://assets/audio/sfx/land.ogg",
	"sword_swing": "res://assets/audio/sfx/sword_swing.ogg",
	"hit": "res://assets/audio/sfx/hit.ogg",
	"player_hurt": "res://assets/audio/sfx/player_hurt.ogg",
	"player_death": "res://assets/audio/sfx/player_death.ogg",
	# Items
	"coin_pickup": "res://assets/audio/sfx/coin_pickup.ogg",
	"item_pickup": "res://assets/audio/sfx/item_pickup.ogg",
	# UI
	"ui_click": "res://assets/audio/sfx/ui_click.ogg",
	"ui_hover": "res://assets/audio/sfx/ui_hover.ogg",
	"pause": "res://assets/audio/sfx/pause.ogg",
	# Virtue
	"virtue_gain": "res://assets/audio/sfx/virtue_gain.ogg",
	"virtue_loss": "res://assets/audio/sfx/virtue_loss.ogg",
	# Enemies
	"enemy_hit": "res://assets/audio/sfx/enemy_hit.ogg",
	"enemy_death": "res://assets/audio/sfx/enemy_death.ogg",
	# Environment
	"bell": "res://assets/audio/sfx/bell.ogg",
	"door": "res://assets/audio/sfx/door.ogg",
}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	_setup_audio_players()
	_setup_audio_buses()
	print("AudioManager initialized")


func _setup_audio_players() -> void:
	"""Create music player and SFX player pool"""
	# Music player
	music_player = AudioStreamPlayer.new()
	music_player.name = "MusicPlayer"
	music_player.bus = BUS_MUSIC
	add_child(music_player)

	# SFX player pool
	for i in range(MAX_SFX_PLAYERS):
		var sfx_player = AudioStreamPlayer.new()
		sfx_player.name = "SFXPlayer_%d" % i
		sfx_player.bus = BUS_SFX
		add_child(sfx_player)
		sfx_players.append(sfx_player)


func _setup_audio_buses() -> void:
	"""Configure audio bus volumes"""
	set_master_volume(master_volume)
	set_music_volume(music_volume)
	set_sfx_volume(sfx_volume)


## Play music track
func play_music(track_name: String, fade_in: bool = true) -> void:
	if track_name == current_music and music_player.playing:
		return  # Already playing this track

	if track_name not in music_tracks:
		push_warning("Music track not found: %s" % track_name)
		return

	var track_path = music_tracks[track_name]
	if not ResourceLoader.exists(track_path):
		push_warning("Music file not found: %s" % track_path)
		return

	# Stop current music
	if music_player.playing:
		if fade_in:
			await _fade_out_music()
		else:
			music_player.stop()

	# Load and play new track
	var audio_stream = load(track_path)
	music_player.stream = audio_stream
	music_player.play()
	current_music = track_name

	if fade_in:
		_fade_in_music()

	music_changed.emit(track_name)
	print("Playing music: %s" % track_name)


## Stop music
func stop_music(fade_out: bool = true) -> void:
	if not music_player.playing:
		return

	if fade_out:
		await _fade_out_music()
	else:
		music_player.stop()

	current_music = ""


## Play sound effect
func play_sfx(sfx_name: String, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
	if sfx_name not in sfx_library:
		push_warning("SFX not found: %s" % sfx_name)
		return

	var sfx_path = sfx_library[sfx_name]
	if not ResourceLoader.exists(sfx_path):
		# SFX file doesn't exist yet (placeholder phase), silently skip
		return

	# Find available player
	var player = _get_available_sfx_player()
	if not player:
		push_warning("No available SFX players (all %d busy)" % MAX_SFX_PLAYERS)
		return

	# Load and play
	var audio_stream = load(sfx_path)
	player.stream = audio_stream
	player.volume_db = volume_db
	player.pitch_scale = pitch_scale
	player.play()


## Get an available SFX player from pool
func _get_available_sfx_player() -> AudioStreamPlayer:
	for player in sfx_players:
		if not player.playing:
			return player
	return null


## Fade out music
func _fade_out_music(duration: float = 1.0) -> void:
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", -80.0, duration)
	await tween.finished
	music_player.stop()
	music_player.volume_db = 0.0


## Fade in music
func _fade_in_music(duration: float = 1.0) -> void:
	music_player.volume_db = -80.0
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", 0.0, duration)


## Set master volume (0.0 - 1.0)
func set_master_volume(volume: float) -> void:
	master_volume = clampf(volume, 0.0, 1.0)
	var db = linear_to_db(master_volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(BUS_MASTER), db)
	volume_changed.emit(BUS_MASTER, master_volume)


## Set music volume (0.0 - 1.0)
func set_music_volume(volume: float) -> void:
	music_volume = clampf(volume, 0.0, 1.0)
	var bus_idx = AudioServer.get_bus_index(BUS_MUSIC)
	if bus_idx >= 0:
		var db = linear_to_db(music_volume)
		AudioServer.set_bus_volume_db(bus_idx, db)
		volume_changed.emit(BUS_MUSIC, music_volume)


## Set SFX volume (0.0 - 1.0)
func set_sfx_volume(volume: float) -> void:
	sfx_volume = clampf(volume, 0.0, 1.0)
	var bus_idx = AudioServer.get_bus_index(BUS_SFX)
	if bus_idx >= 0:
		var db = linear_to_db(sfx_volume)
		AudioServer.set_bus_volume_db(bus_idx, db)
		volume_changed.emit(BUS_SFX, sfx_volume)


## Mute/unmute master bus
func set_muted(muted: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index(BUS_MASTER), muted)


## Play music based on game phase
func play_music_for_phase(phase: int) -> void:
	match phase:
		0:  # GameManager.PlayerPhase.CHILD
			play_music("phase_1")
		1:  # GameManager.PlayerPhase.ADOLESCENT
			play_music("phase_2")
		2:  # GameManager.PlayerPhase.KNIGHT
			play_music("phase_3")
		3:  # GameManager.PlayerPhase.ELDER
			play_music("phase_4")
