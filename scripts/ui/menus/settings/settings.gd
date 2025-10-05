class_name Settings extends Control

@onready var music_setting: SliderSetting = $TabContainer/Sound/Sound/VBoxContainer/Music_Setting
@onready var sfx_setting: SliderSetting = $TabContainer/Sound/Sound/VBoxContainer/SFX_Setting
@onready var hide_button: Button = $TabContainer/Sound/Sound/VBoxContainer/Hide

func _ready() -> void:
	hide()

func appear_tween() -> Tween:
	show()
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(self, "position", Vector2.ZERO, StatManagerGlobal.ui_speed).set_trans(Tween.TRANS_ELASTIC).from(Vector2(-350, 0))
	return tween

func _disappear_tween() -> Tween:
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(self, "position", Vector2(-350, 0), StatManagerGlobal.ui_speed).set_trans(Tween.TRANS_ELASTIC)
	return tween

func _on_hide_pressed() -> void:
	await _disappear_tween().finished
	hide()

func _on_music_setting_value_changed(value: float) -> void:
	MusicManagerGlobal.music_volume = value / 100
	for music_node: AudioStreamPlayer in get_tree().get_nodes_in_group("Music"):
		music_node.volume_linear = MusicManagerGlobal.music_volume

func _on_sfx_setting_value_changed(value: float) -> void:
	MusicManagerGlobal.sfx_volume = value / 100
	for sfx_node in get_tree().get_nodes_in_group("SFX"):
		sfx_node.volume_linear = MusicManagerGlobal.sfx_volume
