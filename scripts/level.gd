class_name Level extends Node2D

const DEAD_HOOK: PackedScene = preload("uid://c87lxb0i7fp4k")

const DEAD_HOOK_TILES: Array[Vector2] = [
	Vector2(1,0), Vector2(0,1), Vector2(2,1), Vector2(1,2),
]

signal consumption_area_added(polygon: CollisionPolygon2D)
signal collecting_pipe_found()
signal won()
signal lost()

@export_file("*.tscn") var next_level: String
@export_range(0,9) var easy_enemies: int = 3
@export_range(0,9) var medium_enemies: int = 0
@export_range(0,9) var hard_enemies: int = 0

@onready var border: TileMapLayer = $Border
@onready var consumption_scan: Area2D = $ConsumptionScan
@onready var collection_area: NavigationRegion2D = $CollectionArea
@onready var hooks: Node2D = $Hooks
@onready var enemies: Node2D = $Enemies
@onready var time_limit: Timer = $TimeLimit


var player: Player
var pipe: Pipe

func _ready() -> void:
	GameManagerGlobal.ui.show()
	StatManagerGlobal.current_level = self
	StatManagerGlobal.depleted_hp = 0
	GameManagerGlobal.start_dialogue()
	player = get_tree().get_first_node_in_group("Player")
	
	consumption_area_added.connect(_on_consumption_area_added)
	time_limit.timeout.connect(_on_time_limit_timeout)
	won.connect(_on_won)
	
	_place_tiles_with_scenes()

func _place_tiles_with_scenes() -> void:
	for tile_position: Vector2 in border.get_used_cells(): 
		var tile_id: Vector2 = border.get_cell_atlas_coords(tile_position)
		if DEAD_HOOK_TILES.has(tile_id):
			var dead_hook: DeadHook = DEAD_HOOK.instantiate()
			var dead_hook_position: Vector2 = global_position + border.map_to_local(tile_position)
			hooks.add_child(dead_hook)
			match tile_id:
				Vector2(1,0):
					dead_hook.rotation_degrees = 180
					dead_hook.side = DeadHook.Sides.CEILING
				Vector2(0,1):
					dead_hook.rotation_degrees = 90
					dead_hook.side = DeadHook.Sides.LEFT_WALL
				Vector2(2,1):
					dead_hook.rotation_degrees = 270
					dead_hook.side = DeadHook.Sides.RIGHT_WALL
				Vector2(1,2):
					dead_hook.rotation_degrees = 0
					dead_hook.side = DeadHook.Sides.FLOOR
			dead_hook.global_position = dead_hook_position

func _on_consumption_area_added(polygon: CollisionPolygon2D) -> void:
	#var navigation_polygon: NavigationPolygon = NavigationPolygon.new()
	#var correct_polygon_array: PackedInt32Array = polygon.polygon.to_byte_array().to_int32_array()
	#navigation_polygon.add_polygon(correct_polygon_array)
	#collection_area.navigation_polygon = navigation_polygon
	#collection_area.bake_navigation_polygon()
	consumption_scan.add_child(polygon)
	
func _on_consumption_scan_body_entered(body: Node2D) -> void:
	if body is Pipe:
		pipe = body
		body.start_collecting()
		collecting_pipe_found.emit()
		await get_tree().create_timer(StatManagerGlobal.collection_time).timeout
		pipe.stop_collecting()
		pipe = null
		consumption_scan.remove_child(consumption_scan.get_child(0))
		if not get_tree().get_nodes_in_group("Rope").is_empty():
			get_tree().get_first_node_in_group("Rope").free()
		player.can_make_rope = true
	else:
		if pipe == null:
			await collecting_pipe_found
		if body is Enemy:
			body.movement = Enemy.MovementStates.COLLECTED
		if body is Player:
			body.can_make_rope = false


func _on_time_limit_timeout() -> void:
	GameManagerGlobal.finish_level(scene_file_path)
	GameManagerGlobal.shop.title.text = "Time over. try again"

func _on_won() -> void:
	GameManagerGlobal.finish_level(next_level)
	StatManagerGlobal.level += 1
