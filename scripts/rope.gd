class_name Rope extends Line2D

signal done()

@export var start_side: DeadHook.Sides

@onready var rope_body: StaticBody2D = $RopeBody

var level: Level

func _ready() -> void:
	level = get_parent()
	done.connect(_on_done)


func start_rope(dead_hook: DeadHook) -> void:
	start_side = dead_hook.side
	var start_position: Vector2 = determine_dead_hook_position(dead_hook)
	add_point(start_position)
	add_point(start_position)

func end_rope(dead_hook: DeadHook) -> void:
	var end_position: Vector2 = determine_dead_hook_position(dead_hook)
	add_point(end_position)
	done.emit()

func add_knot_to_rope(knot_position: Vector2) -> void:
	var last_knot: Vector2 = points.get(points.size()-2)
	add_point(knot_position)
	
	var rope_collision = SegmentShape2D.new()
	rope_collision.a = knot_position
	rope_collision.b = last_knot
	
	var fixated_knot_collision_shape = CollisionShape2D.new()
	fixated_knot_collision_shape.shape = rope_collision
	
	rope_body.add_child(fixated_knot_collision_shape)

func determine_dead_hook_position(dead_hook: DeadHook) -> Vector2:
	var new_position: Vector2 = dead_hook.global_position
	match dead_hook.side:
		DeadHook.Sides.FLOOR:
			new_position += Vector2(0,-5)
		DeadHook.Sides.CEILING:
			new_position += Vector2(0,5)
		DeadHook.Sides.LEFT_WALL:
			new_position += Vector2(5,0)
		DeadHook.Sides.RIGHT_WALL:
			new_position += Vector2(-5,0)
	return new_position

func _on_done() -> void:
	closed = true
	var polygon: CollisionPolygon2D = CollisionPolygon2D.new()
	polygon.polygon = points
	level.consumption_area_added.emit(polygon)
