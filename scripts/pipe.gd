class_name Pipe extends StaticBody2D

@onready var collection_area: Area2D = $CollectionArea

var collecting: bool = false

func start_collecting() -> void:
	collecting = true
	collection_area.monitoring = true

func stop_collecting() -> void:
	collecting = false
	collection_area.monitoring = false

func _on_area_body_entered(body: Node2D) -> void:
	print("test")
	if body is Enemy:
		body.free()
		if get_parent().enemies.get_children().is_empty():
			get_parent().won.emit()
	
