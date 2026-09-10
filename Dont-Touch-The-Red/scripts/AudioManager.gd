extends Node

## Central audio hub. Assign any AudioStream assets to the exported slots in the inspector.

@export_group("Music")
@export var music_stream: AudioStream
@export_range(-40.0, 6.0, 0.5) var music_volume_db := -12.0

@export_group("SFX")
@export var ui_stream: AudioStream
@export var warning_stream: AudioStream
@export var danger_stream: AudioStream
@export var death_stream: AudioStream
@export var coin_stream: AudioStream
@export var rare_coin_stream: AudioStream
@export var epic_coin_stream: AudioStream
@export var powerup_stream: AudioStream
@export var shield_stream: AudioStream
@export var score_boost_stream: AudioStream
@export var magnet_stream: AudioStream
@export_range(-40.0, 6.0, 0.5) var sfx_volume_db := -6.0

var music_enabled := true
var sfx_enabled := true

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var ui_player: AudioStreamPlayer = $UIPlayer
@onready var warning_player: AudioStreamPlayer = $WarningPlayer
@onready var danger_player: AudioStreamPlayer = $DangerPlayer
@onready var death_player: AudioStreamPlayer = $DeathPlayer
@onready var coin_player: AudioStreamPlayer = $CoinPlayer
@onready var powerup_player: AudioStreamPlayer = $PowerupPlayer

func _ready() -> void:
	music_player.volume_db = music_volume_db
	ui_player.volume_db = sfx_volume_db
	warning_player.volume_db = sfx_volume_db+30
	danger_player.volume_db = sfx_volume_db
	death_player.volume_db = sfx_volume_db+20
	coin_player.volume_db = sfx_volume_db
	powerup_player.volume_db = sfx_volume_db
	if music_stream:
		music_player.stream = music_stream
		music_player.play()

func play_ui() -> void:
	
	music_player.stop()
	_play(ui_player, ui_stream)
func set_music_enabled(enabled: bool) -> void:
	music_enabled = enabled
	if music_enabled:
		if music_player.stream and not music_player.playing:
			music_player.play()
	else:
		music_player.stop()

func set_sfx_enabled(enabled: bool) -> void:
	sfx_enabled = enabled

func play_warning() -> void:
	_play(warning_player, warning_stream)

func play_danger() -> void:
	_play(danger_player, danger_stream)

func play_death() -> void:
	_play(death_player, death_stream)

func play_coin(value: int) -> void:
	var stream := coin_stream
	if value >= 8 and epic_coin_stream:
		stream = epic_coin_stream
	elif value >= 3 and rare_coin_stream:
		stream = rare_coin_stream
	_play(coin_player, stream)

func play_powerup(kind: int) -> void:
	var stream := powerup_stream
	if kind == 0 and shield_stream:
		stream = shield_stream
	elif kind == 1 and score_boost_stream:
		stream = score_boost_stream
	elif kind == 2 and magnet_stream:
		stream = magnet_stream
	_play(powerup_player, stream)

func play_sfx(stream: AudioStream) -> void:
	_play(powerup_player, stream)

func _play(player: AudioStreamPlayer, stream: AudioStream) -> void:
	if not stream or not sfx_enabled:
		return
	player.stream = stream
	player.play()
