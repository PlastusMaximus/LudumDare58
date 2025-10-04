class_name Player extends CharacterBody2D

const LINE = preload("uid://dpy6htfcsxbiu")


##The moving speed of the player
@export var speed: int = 500

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var interaction_ray_cast: RayCast2D = $InteractionRayCast

var camera: Camera2D
var current_line: Line2D

func _ready() -> void:
	camera = get_tree().get_first_node_in_group("Camera")

func _physics_process(_delta: float) -> void:
	if _player_movement():
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		animated_sprite.play("idle")
	
	if current_line != null:
		var points: PackedVector2Array = current_line.points
		print(points)
		current_line.set_point_position(points.size()-1, global_position)

##Applies player movement for a given input and returns "true" afterwards.
##Returns false if no movement has been applied.
func _player_movement() -> bool:
	if Input.is_action_pressed("walk_up"):
		velocity = Vector2(0, -speed)
		animated_sprite.play("walk_up")
		interaction_ray_cast.target_position = Vector2(0,-15)
		return true
	elif Input.is_action_pressed("walk_down"):
		velocity = Vector2(0, speed)
		animated_sprite.play("walk_down")
		interaction_ray_cast.target_position = Vector2(0,15)
		return true
	elif Input.is_action_pressed("walk_left"):
		velocity = Vector2(-speed, 0)
		animated_sprite.play("walk_left")
		interaction_ray_cast.target_position = Vector2(-10, 0)
		return true
	elif Input.is_action_pressed("walk_right"):
		velocity = Vector2(speed, 0)
		animated_sprite.play("walk_right")
		interaction_ray_cast.target_position = Vector2(10, 0)
		return true
	return false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		var interactor: Node = interaction_ray_cast.get_collider()
		if current_line == null:
			if get_tree().get_nodes_in_group("Border").has(interactor):
				current_line = LINE.instantiate()
				get_parent().add_child(current_line)
				print(current_line)
				current_line.add_point(global_position)
				current_line.add_point(global_position)
		else:
			if get_tree().get_nodes_in_group("Border").has(interactor):
				current_line.add_point(global_position)
				var polygon: CollisionPolygon2D = CollisionPolygon2D.new()
				current_line.closed = true
				polygon.polygon = current_line.points
				var body: StaticBody2D = StaticBody2D.new()
				body.add_child(polygon)
				get_parent().add_child(body)
			else:
				current_line.add_point(global_position)
