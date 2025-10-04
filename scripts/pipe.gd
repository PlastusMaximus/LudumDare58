class_name Pipe extends StaticBody2D

var collecting: bool = false

func start_collecting() -> void:
	collecting = true

func stop_collecting() -> void:
	collecting = false

func _on_area_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.queue_free()
