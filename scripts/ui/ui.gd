class_name UI extends Control

@onready var hp: RichTextLabel = $Stats/HP
@onready var rope: RichTextLabel = $Stats/Rope
@onready var pins: RichTextLabel = $Stats/Pins
@onready var coins: RichTextLabel = $Stats/Coins
@onready var time_left: RichTextLabel = $Stats/TimeLeft
@onready var level: RichTextLabel = $VBoxContainer/Level

func _process(_delta: float) -> void:
	hp.text = "[wave]HP: " + str(StatManagerGlobal.hp - StatManagerGlobal.depleted_hp) + "[/wave]"
	if get_tree().get_nodes_in_group("Rope").is_empty():
		rope.text = "[wave]Rope: " + str(int(round(StatManagerGlobal.rope /100))) + "m[/wave]"
	else:
		rope.text = "[wave]Rope: " + str(round(StatManagerGlobal.rope - StatManagerGlobal.depleted_rope) / 100) + "m[/wave]"
	pins.text = "[wave]Pins: " +  str(StatManagerGlobal.pins - StatManagerGlobal.depleted_pins) + "[/wave]"
	coins.text = "[wave]Coins: " + str(StatManagerGlobal.coins) + "[/wave]"
	if StatManagerGlobal.current_level is EndlessMode:
		level.text = "[wave]Endless Mode\nWave: " + str(StatManagerGlobal.endless_mode_wave) +"[/wave]"
	else:
		level.text = "[wave]Level: " + str(StatManagerGlobal.level) +"[/wave]"
	if StatManagerGlobal.current_level != null:
		time_left.show()
		
		if StatManagerGlobal.current_level is EndlessMode:
			time_left.text = "[wave]Time until next wave: " + str(int(round(StatManagerGlobal.current_level.time_limit.time_left))) + "[/wave]"
		else:
			if StatManagerGlobal.current_level.time_limit.is_stopped():
				time_left.text = "[wave]No time limit[/wave]"
			else:
				time_left.text = "[wave]Time left: " + str(int(round(StatManagerGlobal.current_level.time_limit.time_left))) + "[/wave]"
	else:
		time_left.hide()
