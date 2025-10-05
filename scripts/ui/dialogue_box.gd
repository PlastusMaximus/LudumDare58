class_name DialogueBox extends Control

signal dialogue_finished()

const level_dialogue: JSON = preload("res://assets/dialogue/level_dialogue.json")

var current_dialogue: Array
var current_dialogue_position: int

var box_appear_position: Vector2 = Vector2(0, 0)
var box_disappear_position: Vector2 = Vector2(0, 280)
var choice_appear_position: Vector2 = Vector2(938, 790)
var choice_disappear_position: Vector2 = Vector2(938, 874)
var mouse_entered_dialogue_box: bool = false
var current_text: String
var text_speed: float = 0.025

@onready var dialogue_text: RichTextLabel = $Dialogue/DialogueText



func _ready() -> void:
	hide()
	await disappear_tween().finished
	dialogue_finished.connect(_on_dialogue_finished)

func appear_tween() -> Tween:
	show()
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", box_appear_position, StatManagerGlobal.ui_speed).set_trans(Tween.TRANS_ELASTIC).from(box_disappear_position)
	return tween

func disappear_tween() -> Tween:
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", box_disappear_position, StatManagerGlobal.ui_speed).set_trans(Tween.TRANS_ELASTIC).from(box_appear_position)
	return tween

func set_dialogue(level: int) -> void:
	current_dialogue = level_dialogue.data.get(str(level))

func clear_dialogue_box() -> void:
	dialogue_text.text = ""
	dialogue_text.visible_characters = 0 as int

func make_text_visible() -> void:
	var written_text: String = ""
	for character in dialogue_text.get_parsed_text() as String:
		dialogue_text.visible_characters += 1 as int
		written_text = written_text + character
		await get_tree().create_timer(text_speed).timeout

func _on_next_pressed() -> void:
	clear_dialogue_box()
	if current_dialogue.get(current_dialogue_position) != null:
		put_next_line()
	else:
		dialogue_finished.emit()

func put_next_line() -> void:
	dialogue_text.text = current_dialogue.get(current_dialogue_position)
	current_dialogue_position += 1
	make_text_visible()

func _on_dialogue_finished() -> void:
	await disappear_tween().finished
	hide()
