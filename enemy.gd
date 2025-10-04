class_name Enemy extends CharacterBody2D

@export var speed: int = 15
@export var collection_speed: int = 150
@export var is_collected: bool = false

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
var pipe: Pipe

func _ready() -> void:
	pipe = get_tree().get_first_node_in_group("Pipe")

func _process(_delta: float) -> void:
	if pipe.collecting and is_collected:
		navigation_agent_2d.target_position = pipe.global_position

func _physics_process(_delta: float) -> void:
	if pipe.collecting and is_collected:
		var next_position = navigation_agent_2d.get_next_path_position()

		var direction = global_position.direction_to(next_position)

		if direction:
			velocity.x = direction.x * collection_speed
			velocity.y = direction.y * collection_speed
		else:
			velocity.x = move_toward(velocity.x, 0, collection_speed)
			velocity.y = move_toward(velocity.y, 0, collection_speed)
	
		_look_at_target(direction)

		move_and_slide()

func _look_at_target(adjusted_direction: Vector2) -> void:
	adjusted_direction.y = 0
	if global_position + adjusted_direction != global_position:
		look_at(global_position + adjusted_direction)
