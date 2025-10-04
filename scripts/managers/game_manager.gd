class_name GameManager extends Node

@onready var ui_layer: CanvasLayer = $UI_Layer
@onready var ui: Control = $UI_Layer/UI
@onready var pause_menu: PauseMenu = $UI_Layer/PauseMenu
@onready var settings: Settings = $UI_Layer/Settings
@onready var music_manager: MusicManager = $UI_Layer/MusicManager
@onready var load_manager: LoadManager = $UI_Layer/LoadManager

##Hides every UI element and then quits the game
func quit_game() -> void:
	_hide_ui()
	load_manager.quit_game()

##Hides every UI element and then loads the selected scene
func load_scene(scene_path: String) -> void:
	_hide_ui()
	load_manager.load_scene(scene_path)

##Hides only the settings (dialogue and microgame boxes have to stay visible) and then pauses the game
func pause_game() ->  void:
	settings.hide()
	pause_menu.show()
	await pause_menu.pause_tween().finished
	get_tree().paused = true

##Hides only the settings (dialogue and microgame boxes have to stay visible) and then unpauses the game
func unpause_game() -> void:
	settings.hide()
	await pause_menu.unpause_tween().finished
	pause_menu.hide()
	get_tree().paused = false

##Hides all UI elements managed by the GameManager.
func _hide_ui() -> void:
	for child: Node in ui_layer.get_children():
		if child is Control:
			child.hide()
