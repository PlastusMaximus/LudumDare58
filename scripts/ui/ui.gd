class_name UI extends Control

@onready var hp: RichTextLabel = $Stats/HP
@onready var rope: RichTextLabel = $Stats/Rope
@onready var pins: RichTextLabel = $Stats/Pins
@onready var coins: RichTextLabel = $Stats/Coins
@onready var time_left: RichTextLabel = $Stats/TimeLeft
@onready var level: RichTextLabel = $VBoxContainer/Level
@onready var tutorial_note: TextureRect = $TutorialNote

var tutorial_visible: bool = false

func _process(_delta: float) -> void:
	hp.text = "[wave]HP: " + str(StatManagerGlobal.hp - StatManagerGlobal.depleted_hp) + "[/wave]"
	if get_tree().get_nodes_in_group("Rope").is_empty():
		rope.text = "[wave]Rope: " + str(int(round(StatManagerGlobal.rope /100))) + "m[/wave]"
	else:
		rope.text = "[wave]Rope: " + str(round(StatManagerGlobal.rope - StatManagerGlobal.depleted_rope) / 100) + "m[/wave]"
	pins.text = "[wave]Pins: " +  str(StatManagerGlobal.pins - StatManagerGlobal.depleted_pins) + "[/wave]"
	coins.text = "[wave]Money: " + str(StatManagerGlobal.coins) + "€[/wave]"
	if StatManagerGlobal.current_level is EndlessMode:
		level.text = "[wave]Endless Mode\nWave: " + str(StatManagerGlobal.endless_mode_wave) +"[/wave]"
	else:
		level.text = "[wave]Level: " + str(StatManagerGlobal.level) +"[/wave]"
	if StatManagerGlobal.current_level != null:
		time_left.show()
		
		if StatManagerGlobal.current_level is EndlessMode:
			time_left.text = "[wave]Time until next wave: " + str(int(round(StatManagerGlobal.current_level.time_limit.time_left))) + "[/wave]"
		else:
			time_left.hide()
	else:
		time_left.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("tutorial"):
		if tutorial_visible:
			await tutorial_disappear_tween().finished
			tutorial_visible = false
		else:
			await tutorial_appear_tween().finished
			tutorial_visible = true

func tutorial_appear_tween() -> Tween:
	var tween: Tween = create_tween()
	tween.tween_property(tutorial_note, "position", Vector2(0, 267), .5).set_trans(Tween.TRANS_ELASTIC).from(Vector2(-600, 267))
	return tween

func tutorial_disappear_tween() -> Tween:
	var tween: Tween = create_tween()
	tween.tween_property(tutorial_note, "position", Vector2(-600, 267), .5).set_trans(Tween.TRANS_ELASTIC).from(Vector2(0, 267))
	
	return tween
