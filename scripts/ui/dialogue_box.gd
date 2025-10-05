class_name DialogueBox extends Control

signal dialogue_finished()

const level_dialogue: JSON = preload("res://assets/dialogue/level_dialogue.json")

var current_dialogue: Array
var current_dialogue_position: int

var box_appear_position: Vector2 = Vector2(0, 0)
var box_disappear_position: Vector2 = Vector2(0, 350)
var mouse_entered_dialogue_box: bool = false
var current_text: String
var text_speed: float = 0.025

@onready var dialogue_text: RichTextLabel = $Dialogue/DialogueText
@onready var bg: ColorRect = $BG



func _ready() -> void:
	hide()
	await disappear_tween().finished
	dialogue_finished.connect(_on_dialogue_finished)

#func _process(delta: float) -> void:
		#print(dialogue_text)
		#print(dialogue_text.text)

func appear_tween() -> Tween:
	show()
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", box_appear_position, StatManagerGlobal.ui_speed).set_trans(Tween.TRANS_ELASTIC).from(box_disappear_position)
	return tween

func disappear_tween() -> Tween:
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", box_disappear_position, StatManagerGlobal.ui_speed).set_trans(Tween.TRANS_ELASTIC).from(box_appear_position)
	return tween

func level_appear_tween() -> Tween:
	var tween: Tween = create_tween()
	tween.tween_property(bg, "modulate", Color.TRANSPARENT, 1).set_trans(Tween.TRANS_LINEAR).from_current()
	return tween

func level_disappear_tween() -> Tween:
	var tween: Tween = create_tween()
	tween.tween_property(bg, "modulate", Color.WHITE, 1).set_trans(Tween.TRANS_LINEAR).from_current()
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

func put_next_line() -> void:
	dialogue_text.text = current_dialogue.get(current_dialogue_position)
	current_dialogue_position += 1
	make_text_visible()

func edge_cases() -> void:
	match StatManagerGlobal.level:
		0:
			if current_dialogue_position == 9:
				await disappear_tween().finished
				await level_appear_tween().finished
				StatManagerGlobal.current_level.opening_animation()
				await StatManagerGlobal.current_level.opening_animation_finished
				await appear_tween().finished
			if current_dialogue_position == 27:
				await GameManagerGlobal.ui.tutorial_appear_tween().finished
				GameManagerGlobal.ui.tutorial_visible = true
		8:
			if current_dialogue_position == 7:
				await level_appear_tween().finished
	

func _on_next_pressed() -> void:
	clear_dialogue_box()
	if current_dialogue.size() > current_dialogue_position:
		put_next_line()
		edge_cases()
	else:
		await level_appear_tween().finished
		dialogue_finished.emit()

func _on_dialogue_finished() -> void:
	current_dialogue_position = 0
	await disappear_tween().finished
	hide()
