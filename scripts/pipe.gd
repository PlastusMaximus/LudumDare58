class_name Pipe extends StaticBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var collection_area: Area2D = $CollectionArea
@onready var collection_sfx: AudioStreamPlayer2D = $CollectionSFX

var collecting: bool = false

func _ready() -> void:
	animated_sprite.play("bought")

func start_collecting() -> void:
	animated_sprite.play("collecting")
	collection_sfx.pitch_scale = randf_range(.9,1.1)
	collection_sfx.play()
	collecting = true
	collection_area.monitoring = true

func stop_collecting() -> void:
	collecting = false
	collection_area.monitoring = false
	animated_sprite.play("activated")
	collection_sfx.stop()

func _on_area_body_entered(body: Node2D) -> void:
	if body is Enemy:
		StatManagerGlobal.coins += body.worth
		body.free()
		if get_parent().enemies.get_children().is_empty():
			if get_parent() is Level and get_parent() is not EndlessMode:
				get_parent().won.emit()
