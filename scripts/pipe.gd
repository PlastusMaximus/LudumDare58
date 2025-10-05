class_name Pipe extends StaticBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var collection_area: Area2D = $CollectionArea

var collecting: bool = false

func _ready() -> void:
	animated_sprite.play("bought")

func start_collecting() -> void:
	animated_sprite.play("collecting")
	collecting = true
	collection_area.monitoring = true

func stop_collecting() -> void:
	collecting = false
	collection_area.monitoring = false
	animated_sprite.play("activated")

func _on_area_body_entered(body: Node2D) -> void:
	if body is Enemy:
		StatManagerGlobal.coins += body.worth
		body.free()
		if get_parent().enemies.get_children().is_empty():
			if get_parent() is Level and get_parent() is not EndlessMode:
				get_parent().won.emit()
