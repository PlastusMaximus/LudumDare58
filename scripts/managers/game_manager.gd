class_name GameManager extends Node

@onready var ui_layer: CanvasLayer = $UI_Layer
@onready var ui: UI = $UI_Layer/UI
@onready var shop: Shop = $UI_Layer/Shop
@onready var dialogue_box: DialogueBox = $UI_Layer/DialogueBox
@onready var pause_menu: PauseMenu = $UI_Layer/PauseMenu
@onready var settings: Settings = $UI_Layer/Settings
@onready var music_manager: MusicManager = $UI_Layer/MusicManager
@onready var load_manager: LoadManager = $UI_Layer/LoadManager

var enemy_movements: Dictionary[Enemy, Enemy.MovementStates] = {}
var shop_open: bool = false
var dialogue_box_open: bool = false

func _ready() -> void:
	

##Hides every UI element and then quits the game
func quit_game() -> void:
	_hide_ui()
	load_manager.quit_game()

func finish_level(scene_path: String) -> void:
	shop.open_shop()
	shop_open = true
	await shop.shop_closed
	shop_open = false
	load_scene(scene_path)

func open_shop_in_endless_mode() -> void:
	shop.open_shop()
	shop_open = true

##Hides every UI element and then loads the selected scene
func load_scene(scene_path: String) -> void:
	_hide_ui()
	dialogue_box.level_disappear_tween()
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

func freeze_enemies_in_endless_mode() -> void:
	for enemy: Enemy in StatManagerGlobal.current_level.enemies.get_children():
		enemy_movements.set(enemy, enemy.movement) 
		enemy.movement = Enemy.MovementStates.STILL

func unfreeze_enemies_in_endless_mode() -> void:
	for enemy: Enemy in StatManagerGlobal.current_level.enemies.get_children():
		if enemy_movements.has(enemy):
			enemy.movement = enemy_movements.get(enemy)
	enemy_movements.clear()

func slushie_freeze_enemies() -> void:
	freeze_enemies_in_endless_mode()
	
	await get_tree().create_timer(5).timeout
	
	unfreeze_enemies_in_endless_mode()

func start_dialogue() -> void:
	dialogue_box_open = true
	freeze_enemies_in_endless_mode()
	dialogue_box.clear_dialogue_box()
	await dialogue_box.appear_tween().finished
	dialogue_box.set_dialogue(StatManagerGlobal.level)
	dialogue_box.put_next_line()
	await dialogue_box.dialogue_finished
	dialogue_box_open = false
	unfreeze_enemies_in_endless_mode()
	
