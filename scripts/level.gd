class_name Level extends Node2D

const ENEMY: PackedScene = preload("uid://ly3n4ywnpm82")

signal consumption_area_added(polygon: CollisionPolygon2D)
signal won()
signal lost()

@export_file("*.tscn") var next_level: String
@export_range(0,9) var easy_enemies: int = 3
@export_range(0,9) var medium_enemies: int = 0
@export_range(0,9) var hard_enemies: int = 0
@export_range(0,2) var allowed_movement_states = 2
@export var randomized_spawn: bool = true

@onready var consumption_scan: Area2D = $ConsumptionScan
@onready var collection_area: NavigationRegion2D = $CollectionArea
@onready var enemies: Node2D = $Enemies
@onready var hooks: Node2D = $Hooks


var player: Player
var pipe: Pipe

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	pipe =  get_tree().get_first_node_in_group("Pipe")
	
	consumption_area_added.connect(_on_consumption_area_added)
	won.connect(_on_won)
	
	if randomized_spawn:
		for i: int in range(0, easy_enemies):
			var enemy: Enemy = ENEMY.instantiate()
			enemy.movement = randi_range(0,allowed_movement_states)
			enemies.add_child(enemy)
		
		for i: int in range(0, medium_enemies):
			enemies.add_child(ENEMY.instantiate())
		
		for i: int in range(0, hard_enemies):
			enemies.add_child(ENEMY.instantiate())

func _on_consumption_area_added(polygon: CollisionPolygon2D) -> void:
	#var navigation_polygon: NavigationPolygon = NavigationPolygon.new()
	#var correct_polygon_array: PackedInt32Array = polygon.polygon.to_byte_array().to_int32_array()
	#navigation_polygon.add_polygon(correct_polygon_array)
	#collection_area.navigation_polygon = navigation_polygon
	#collection_area.bake_navigation_polygon()
	consumption_scan.add_child(polygon)
	
func _on_consumption_scan_body_entered(body: Node2D) -> void:
	if body is Pipe:
		body.start_collecting()
	if body is Enemy:
		body.movement = Enemy.MovementStates.COLLECTED
	if body is Player:
		body.can_make_rope = false
		await get_tree().create_timer(5).timeout
		pipe.stop_collecting()
		consumption_scan.remove_child(consumption_scan.get_child(0))
		get_tree().get_first_node_in_group("Rope").queue_free()
		for hook: Hook in hooks.get_children():
			hook.queue_free()
		body.can_make_rope = true

func _on_border_area_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.rotation_degrees += randi_range(135,225)

func _on_won() -> void:
	GameManagerGlobal.load_scene(next_level)
