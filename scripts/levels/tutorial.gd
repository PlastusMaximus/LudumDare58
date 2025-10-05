class_name Tutorial extends Level

func _ready() -> void:
	super._ready()
	player.animated_sprite.play("absolute_beginning")

signal opening_animation_finished()

func opening_animation() -> void:
	await player_tween().finished
	player.animated_sprite.play("reading")
	await player.animated_sprite.animation_finished
	player.animated_sprite.play("reading_idle")
	opening_animation_finished.emit()
	

func player_tween() -> Tween:
	var tween: Tween = create_tween().set_parallel(true)
	player.collision_shape.disabled = true
	tween.tween_property(player, "scale", Vector2.ONE, 1).set_trans(Tween.TRANS_BOUNCE).from(Vector2(.5,.5))
	tween.tween_property(player, "position", Vector2(104,74), 1).set_trans(Tween.TRANS_LINEAR).from(Vector2(104,97))
	player.collision_shape.disabled = false
	return tween
