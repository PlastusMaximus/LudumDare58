class_name Enemy extends CharacterBody2D
 
enum MovementStates {
	STILL,
	FORWARD,
	SPIN,
	COLLECTED
}


@export var speed: int = 150
@export var collection_speed: int = 300
@export var damage: int = 1
@export var movement: MovementStates = MovementStates.STILL

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

var level: Level
var pipe: Pipe
var player: Player
var hover: Tween

func _ready() -> void:
	level = get_parent().get_parent()
	pipe = get_tree().get_first_node_in_group("Pipe")
	player = get_tree().get_first_node_in_group("Player")
	if level.randomized_spawn:
		global_position = Vector2(randi_range(0,1920), randf_range(0,1080))
	hover = hover_tween().set_loops(100)

func _process(delta: float) -> void:
	match movement:
		MovementStates.STILL:
			velocity = Vector2.ZERO
		MovementStates.FORWARD:
			hover.stop()
			velocity = -transform.y * speed
		MovementStates.SPIN:
			hover.stop()
			velocity = transform.y * speed
			rotate(1 * delta)
		MovementStates.COLLECTED:
			if pipe.collecting:
				hover.stop()
				determine_new_target(pipe.global_position)
				await get_tree().create_timer(5).timeout
				movement = MovementStates.FORWARD
	move_and_slide()

func _physics_process(_delta: float) -> void:
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

func determine_new_target(target_position: Vector2) -> void:
	navigation_agent_2d.target_position = target_position

func _look_at_target(adjusted_direction: Vector2) -> void:
	if global_position + adjusted_direction != global_position:
		look_at(global_position + adjusted_direction)

func hover_tween() ->  Tween:
	var tween: Tween = create_tween().set_loops(100)
	
	tween.tween_property(self, "global_position", global_position + Vector2(0, 2), 1).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "global_position", global_position + Vector2(0, -2), 1).set_trans(Tween.TRANS_CUBIC)
	
	return tween


func _on_collision_area_body_entered(body: Node2D) -> void:
	if (body is Enemy and body != self) or body is Pipe:
		rotation_degrees += 180
	
