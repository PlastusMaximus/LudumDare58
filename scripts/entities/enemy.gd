class_name Enemy extends CharacterBody2D
 
enum MovementStates {
    STILL,
    FORWARD,
    SPIN,
    COLLECTED
}

enum Difficulty {
    TUTORIAL,
    EASY,
    MEDIUM,
    HARD
}



@export var collection_speed: int = 300

@export var movement: MovementStates = MovementStates.STILL
@export var difficulty: Difficulty = Difficulty.TUTORIAL

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var collision_sfx: AudioStreamPlayer2D = $CollisionSFX

var speed: int = 150
var damage: int = 1
var worth: int = 1
var spin_degrees: int = 1

var level: Level
var pipe: Pipe
var player: Player
var hover: Tween
var turn_timer: Timer = Timer.new()

func _ready() -> void:
    level = get_parent().get_parent()
    pipe = get_tree().get_first_node_in_group("Pipe")
    player = get_tree().get_first_node_in_group("Player")
    turn_timer.wait_time = 10
    add_child(turn_timer)
    turn_timer.timeout.connect(_on_turn_timer_timeout)
    turn_timer.start()
    apply_difficulty()
    if level is EndlessMode:
        global_position = Vector2(randi_range(16,464), randf_range(16,266))
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
            rotate(spin_degrees * delta)
        MovementStates.COLLECTED:
            if pipe.collecting:
                hover.stop()
                determine_new_target(pipe.global_position)
                await get_tree().create_timer(StatManagerGlobal.collection_time).timeout
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

func apply_difficulty() -> void:
    match difficulty:
        Difficulty.TUTORIAL:
            speed = 10
            damage = 0
            worth = 1
            animated_sprite.play("tutorial")
        Difficulty.EASY:
            speed = 50
            damage = 1
            worth = 1
            animated_sprite.play("easy")
        Difficulty.MEDIUM:
            scale = Vector2(2,2)
            speed = 75
            damage = 2
            worth = 2
            animated_sprite.play("medium")
        Difficulty.HARD:
            scale = Vector2(2.5,2.5)
            speed = 100
            damage = 3
            worth = 3
            animated_sprite.play("hard")

func _on_collision_area_body_entered(_body: Node2D) -> void:
    collision_sfx.pitch_scale = randf_range(.8,1.2)
    collision_sfx.play()
    
    rotation_degrees += randi_range(135,225)
    
func _on_turn_timer_timeout() -> void:
    match movement:
        MovementStates.FORWARD:
            rotation_degrees += 180
        MovementStates.SPIN:
            if spin_degrees == 1:
                spin_degrees = -1
            else:
                spin_degrees = 1
