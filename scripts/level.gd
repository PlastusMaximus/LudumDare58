class_name Level extends Node2D

signal consumption_area_added(polygon: CollisionPolygon2D)

@onready var consumption_scan: Area2D = $ConsumptionScan
@onready var collection_area: NavigationRegion2D = $CollectionArea

var player: Player
var pipe: Pipe

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	pipe =  get_tree().get_first_node_in_group("Pipe")
	
	consumption_area_added.connect(_on_consumption_area_added)

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
		await get_tree().create_timer(5).timeout
		body.stop_collecting()
		consumption_scan.remove_child(consumption_scan.get_child(0)) 
		get_tree().get_first_node_in_group("Rope").queue_free()
	if body is Enemy:
		body.is_collected = true
