class_name DeadHook extends StaticBody2D

const PIPE: PackedScene = preload("uid://cauuyn3ddtg0p")

enum Sides {
	FLOOR,
	CEILING,
	LEFT_WALL,
	RIGHT_WALL,
}

@export var side: Sides = Sides.FLOOR

func turn_into_pipe() -> void:
	var pipe: Pipe = PIPE.instantiate()
	pipe.global_position = global_position
	pipe.rotation_degrees = rotation_degrees
	get_parent().pipes.add_child(pipe)
