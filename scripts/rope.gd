class_name Rope extends Line2D

signal done()

@onready var rope_body: StaticBody2D = $RopeBody

var level: Level

func _ready() -> void:
	level = get_parent()
	done.connect(_on_done)


func start_rope_at_border(border_position: Vector2) -> void:
	add_point(border_position)
	add_point(border_position)

func add_knot_to_rope(knot_position: Vector2) -> void:
	var last_knot: Vector2 = points.get(points.size()-2)
	print(points)
	add_point(knot_position)
	print(points)
	
	var rope_collision = SegmentShape2D.new()
	rope_collision.a = knot_position
	rope_collision.b = last_knot
	
	var fixated_knot_collision_shape = CollisionShape2D.new()
	fixated_knot_collision_shape.shape = rope_collision
	
	rope_body.add_child(fixated_knot_collision_shape)
	

func _on_done() -> void:
	closed = true
	var polygon: CollisionPolygon2D = CollisionPolygon2D.new()
	polygon.polygon = points
	level.consumption_area_added.emit(polygon)
