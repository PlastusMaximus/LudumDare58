class_name Rope extends Line2D

signal done()

const ROPE_SOUNDS: Array[AudioStreamMP3] = [
	preload("uid://o65nw3820nc"),
	preload("uid://beqa48l8k1afe"),
	preload("uid://c413y0deq7a44"),
	preload("uid://q12js0ak5l30"),
	preload("uid://r2d55xmwdoa5"),
	preload("uid://42xf1lo2q4vm"),
	preload("uid://fselga5jlqa1"),
	preload("uid://bhvf52v5tlx8w")
]

@export var start_side: DeadHook.Sides

@onready var rope_body: StaticBody2D = $RopeBody
@onready var rope_sounds: AudioStreamPlayer2D = $RopeSounds

var level: Level
var player: Player
var rope_done: bool = false

func _ready() -> void:
	level = get_parent()
	player = get_tree().get_first_node_in_group("Player")
	done.connect(_on_done)

func _process(_delta: float) -> void:
	if not rope_done:
		set_point_position(points.size()-1, player.global_position)
		
		if not rope_sounds.playing:
			rope_sounds.stream = ROPE_SOUNDS.pick_random()
			rope_sounds.pitch_scale = randf_range(.9,1.1)
			rope_sounds.play()
		
		var collision: CollisionShape2D = rope_body.get_child(rope_body.get_children().size()-1) 
		var segment: SegmentShape2D = collision.shape
		segment.b = player.global_position
		
		StatManagerGlobal.depleted_rope = determine_player_leeway()

func determine_player_leeway() -> float:
	var leeway: float = 0
	var last_point: Vector2 = points.get(0)
	for point: Vector2 in points:
		leeway += point.distance_to(last_point)
		last_point = point
	return leeway

func start_rope(dead_hook: DeadHook) -> void:
	start_side = dead_hook.side
	var start_position: Vector2 = determine_dead_hook_position(dead_hook)
	add_point(start_position)
	add_knot_to_rope(start_position)

func end_rope(dead_hook: DeadHook) -> void:
	var end_position: Vector2 = determine_dead_hook_position(dead_hook)
	add_point(end_position)
	rope_done = true
	StatManagerGlobal.depleted_rope = 0
	StatManagerGlobal.depleted_pins = 0
	done.emit()

func add_knot_to_rope(knot_position: Vector2) -> void:
	set_point_position(points.size()-1, knot_position)
	add_point(player.global_position)
	
	if not rope_body.get_children().is_empty():
		var last_collision: CollisionShape2D = rope_body.get_child(rope_body.get_children().size()-1) 
		var last_segment: SegmentShape2D = last_collision.shape
		last_segment.b = knot_position
	
	var rope_collision = SegmentShape2D.new()
	rope_collision.a = knot_position
	rope_collision.b = player.global_position
	
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

func action_tween() -> Tween:
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate", Color.PURPLE, (float(StatManagerGlobal.collection_time) / 5) * 4).set_trans(Tween.TRANS_SINE).from(Color.WHITE)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, (float(StatManagerGlobal.collection_time) / 5) * 1).set_trans(Tween.TRANS_SINE).from(Color.PURPLE)
	return tween

func _on_done() -> void:
	closed = true
	var polygon: CollisionPolygon2D = CollisionPolygon2D.new()
	polygon.polygon = points
	level.consumption_area_added.emit(polygon)
	action_tween()
