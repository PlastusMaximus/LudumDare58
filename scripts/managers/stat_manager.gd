class_name StatManager extends Node

##The time that UI elements are supposed to take when moving
@export_range(0.1,3) var ui_speed: float = 1
@export var level: int = 0
@export var hp: int = 5
@export var rope: float = 300
@export var pins: int = 1
@export var coins: int = 0
@export var collection_time: int = 3
@export_range(0,8) var shield_pieces: int = 8
@export var slushies: int = 0
@export var endless_mode_wave: int = 0

var current_level: Level
var depleted_rope: float = 0
var depleted_pins: int = 0
var depleted_hp: int = 0
