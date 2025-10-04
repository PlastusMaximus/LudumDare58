class_name DynamicButton extends Button

@export var planned_pos: Vector2

var button_squeak: AudioStreamPlayer = AudioStreamPlayer.new()
var button_press: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready() -> void:
	planned_pos = global_position
	pivot_offset = size/2
	#TODO!
	button_squeak.stream = null
	#TODO!
	button_press.stream = null
	button_squeak.add_to_group("SFX")
	button_press.add_to_group("SFX")
	add_child(button_squeak)
	add_child(button_press)
	mouse_entered.connect(hover_tween)
	mouse_exited.connect(deselect_tween)
	pressed.connect(pressed_tween)
	

func hover_tween() -> Tween:
	if not disabled:
		var tween: Tween = create_tween().set_parallel(true)
		tween.tween_property(self, "rotation_degrees", randi_range(-10, 10), 0.1).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "scale", Vector2(1.25,1.25), 0.1).set_trans(Tween.TRANS_CUBIC)
		button_squeak.pitch_scale = randf_range(0.95,1.05)
		button_squeak.play()
		return tween
	return null

func deselect_tween() -> Tween:
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(self, "rotation_degrees", 0, 0.1).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_CUBIC)
	return tween

func pressed_tween() -> void:
	button_press.pitch_scale = randf_range(0.95,1.05)
	button_press.play(0.22)
