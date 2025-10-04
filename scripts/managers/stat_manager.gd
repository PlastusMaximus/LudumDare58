class_name StatManager extends Node

##The time that UI elements are supposed to take when moving
@export_range(0.1,3) var ui_speed: float = 1
@export var hp: int = 5
@export var rope: float = 500
@export var coins: int = 0

var current_level: Level
