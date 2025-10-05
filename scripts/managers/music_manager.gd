class_name MusicManager extends Node

@export var music_volume: float = 1
@export var sfx_volume: float = 1

@onready var theme_1: AudioStreamPlayer = $Theme1
@onready var theme_2: AudioStreamPlayer = $Theme2

func pause_track(track: AudioStreamPlayer) -> void:
	track.stop()

func unpause_track(track: AudioStreamPlayer) -> void:
	track.play()
