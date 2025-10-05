class_name MainMenu extends Control

const MAIN_MENU: String = "res://scenes/ui/menus/main_menu.tscn"

@onready var title: RichTextLabel = $Background/CenterContainer/Title
@onready var buttons: GridContainer = $Menu/HBoxContainer/VBoxContainer/Buttons
@onready var settings: Settings = GameManagerGlobal.settings

func _ready() -> void:
	MusicManagerGlobal.pause_track(MusicManagerGlobal.theme_1)
	MusicManagerGlobal.unpause_track(MusicManagerGlobal.theme_2)
	appear_tween()

func appear_tween() -> Tween:
	var tween: Tween = create_tween().set_parallel(true)
	var index: int = 0
	for button: DynamicButton in buttons.get_children():
		tween.tween_property(button, "position", Vector2(0, 105 * index), StatManagerGlobal.ui_speed).set_trans(Tween.TRANS_ELASTIC).from(Vector2(0, -600))
		index += 1
	return tween

func _disappear_tween() -> Tween:
	var tween: Tween = create_tween().set_parallel(true)
	for button: DynamicButton in buttons.get_children():
		tween.tween_property(button, "position", Vector2(0, -600), StatManagerGlobal.ui_speed).set_trans(Tween.TRANS_ELASTIC)
	return tween

func _on_start_pressed() -> void:
	await _disappear_tween().finished
	MusicManagerGlobal.pause_track(MusicManagerGlobal.theme_2)
	GameManagerGlobal.load_scene("res://scenes/level/tutorial.tscn")

func _on_settings_pressed() -> void:
	if settings.visible:
		await settings._disappear_tween().finished
		settings.hide()
	else:
		settings.show()
		settings.appear_tween()

func _on_quit_pressed() -> void:
	await _disappear_tween().finished
	GameManagerGlobal.quit_game()
