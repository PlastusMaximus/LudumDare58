class_name Player extends CharacterBody2D

const ROPE: PackedScene = preload("uid://dpy6htfcsxbiu")


##The moving speed of the player
@export var speed: int = 100
@export var can_make_rope: bool = true

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var interaction_ray_cast: RayCast2D = $InteractionRayCast

var current_rope: Rope

func _physics_process(_delta: float) -> void:
	if _player_movement():
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		animated_sprite.play("idle")

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
	if event.is_action_pressed("interact") and can_make_rope:
		var interactor: Node = interaction_ray_cast.get_collider()
		if current_rope == null:
			if interactor is DeadHook:
				current_rope = ROPE.instantiate()
				get_parent().add_child(current_rope)
				current_rope.start_rope(interactor)
		else:
			if interactor is DeadHook:
				if current_rope.start_side == interactor.side:
					current_rope.end_rope(interactor)
					current_rope = null
				else:
					current_rope.add_knot_to_rope(current_rope.determine_dead_hook_position(interactor))
			else:
				current_rope.add_knot_to_rope(global_position)


func _on_area_body_entered(body: Node2D) -> void:
	if body is Enemy:
		if StatManagerGlobal.hp > 0:
			StatManagerGlobal.hp -= body.damage
		else:
			get_parent().lost.emit()
			GameManagerGlobal.quit_game()
			queue_free()
