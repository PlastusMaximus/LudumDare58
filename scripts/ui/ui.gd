extends Control

@onready var hp: RichTextLabel = $Stats/HP
@onready var rope: RichTextLabel = $Stats/Rope
@onready var coins: RichTextLabel = $Stats/Coins
@onready var time_left: RichTextLabel = $Stats/TimeLeft

func _process(_delta: float) -> void:
	hp.text = "[wave]HP: " + str(StatManagerGlobal.hp) + "[/wave]"
	rope.text = "[wave]Rope: " + str(StatManagerGlobal.rope /100) + "m[/wave]"
	coins.text = "[wave]Coins: " + str(StatManagerGlobal.coins) + "[/wave]"
	if StatManagerGlobal.current_level != null:
		time_left.show()
		if StatManagerGlobal.current_level.time_limit.is_stopped():
			time_left.text = "[wave]No time limit[/wave]"
		else:
			time_left.text = "[wave]Time left: " + str(int(round(StatManagerGlobal.current_level.time_limit.time_left))) + "[/wave]"
	else:
		time_left.hide()
