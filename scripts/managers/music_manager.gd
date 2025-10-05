class_name MusicManager extends Node

@export var music_volume: float = 1
@export var sfx_volume: float = 1

@onready var theme_1: AudioStreamPlayer = $Theme1
@onready var theme_2: AudioStreamPlayer = $Theme2

func _ready() -> void:
	MusicManagerGlobal.theme_1.play()
	MusicManagerGlobal.theme_1.stream_paused = true
	MusicManagerGlobal.theme_2.play()

func pause_track(track: AudioStreamPlayer) -> void:
	track.stream_paused = true

func unpause_track(track: AudioStreamPlayer) -> void:
	track.stream_paused = false
