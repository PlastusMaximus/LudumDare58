class_name Shop extends Control

signal shop_closed()

@onready var title: RichTextLabel = $Background/CenterContainer/Title
@onready var buttons: GridContainer = $Menu/HBoxContainer/VBoxContainer/Buttons
@onready var music: AudioStreamPlayer = $Music
@onready var settings: Settings = GameManagerGlobal.settings

@onready var start: DynamicButton = $Menu/HBoxContainer/VBoxContainer/Buttons/Start
@onready var more_rope: DynamicButton = $Menu/HBoxContainer/VBoxContainer/Buttons/MoreRope
@onready var more_pins: DynamicButton = $Menu/HBoxContainer/VBoxContainer/Buttons/MorePins
@onready var more_hp: DynamicButton = $Menu/HBoxContainer/VBoxContainer/Buttons/MoreHP
@onready var more_time: DynamicButton = $Menu/HBoxContainer/VBoxContainer/Buttons/MoreTime
@onready var more_collection_time: DynamicButton = $Menu/HBoxContainer/VBoxContainer/Buttons/MoreCollectionTime
@onready var buy_shield: DynamicButton = $Menu/HBoxContainer/VBoxContainer/Buttons/BuyShield
@onready var buy_slushie: DynamicButton = $Menu/HBoxContainer/VBoxContainer/Buttons/BuySlushie

var times_rope_was_bought: int = 0
var times_pin_was_bought: int = 0
var times_hp_where_bought: int = 0
var times_collection_time_was_bought: int = 0
var times_shield_was_bought: int = 0
var times_slushie_was_bought: int = 0

var rope_price: int = 5
var pin_price: int = 5
var hp_price: int = 5
var collection_time_price: int = 5
var shield_price: int = 10
var slushie_price: int = 20

func open_shop() -> void:
	show()
	appear_tween()
	refresh_price_tags()
	for i: int in range(StatManagerGlobal.level+1, buttons.get_children().size()-1):
		if buttons.get_child(i):
			buttons.get_child(i).text = "[Locked. Finish level " + str(i) +" to unlock]"
	
func refresh_price_tags() -> void:
	
	if StatManagerGlobal.level >= 7:
		title.text = "You've truly seen it all!"
		start.text = "Endless Mode"
	
	
	more_rope.text = "[" + str(rope_price) + "€] More rope (+ 1 meter.)\n(Currently " + str(int(round(StatManagerGlobal.rope / 100))) + " meters)"
	if StatManagerGlobal.coins < rope_price:
		more_rope.disabled = true
	else:
		more_rope.disabled = false
	
	more_pins.text = "[" + str(pin_price) + "€] Addional pin\n(Currently " + str(StatManagerGlobal.pins) + " pins)"
	if StatManagerGlobal.coins < pin_price:
		more_pins.disabled = true
	else:
		more_pins.disabled = false
	
	more_hp.text = "[" + str(hp_price) + "€] Addional health point\n(Currently " + str(StatManagerGlobal.hp) + " HP)"
	if StatManagerGlobal.coins < hp_price:
		more_hp.disabled = true
	else:
		more_hp.disabled = false
	
	more_collection_time.text = "[" + str(collection_time_price) + "€] Longer collection time (+1 Second)\n(Currently " + str(StatManagerGlobal.collection_time) + " seconds)"
	if StatManagerGlobal.coins < collection_time_price:
		more_collection_time.disabled = true
	else:
		more_collection_time.disabled = false
	
	buy_shield.text = "[" + str(shield_price) + "€] Buy Shield (" + str(times_shield_was_bought) + "/8)"
	if StatManagerGlobal.coins < shield_price:
		buy_shield.disabled = true
	else:
		buy_shield.disabled = false
	if times_shield_was_bought >= 8:
		buy_shield.text = "Sold out!"
		buy_shield.disabled = true
	
	buy_slushie.text = "[" + str(slushie_price) + "€] Buy Slushie (freeze for 5 seconds)\n(Currently " + str(StatManagerGlobal.slushies) + ")"
	if StatManagerGlobal.coins < slushie_price:
		buy_slushie.disabled = true
	else:
		buy_slushie.disabled = false
	if times_slushie_was_bought > 0:
		buy_slushie.text = "Sold out!"
		buy_slushie.disabled = true

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
	shop_closed.emit()
	_disappear_tween()
	hide()

func _on_more_rope_pressed() -> void:
	StatManagerGlobal.coins -= rope_price
	StatManagerGlobal.rope += 100
	times_rope_was_bought += 1
	rope_price += times_rope_was_bought
	refresh_price_tags()

func _on_more_pins_pressed() -> void:
	StatManagerGlobal.coins -= pin_price
	StatManagerGlobal.pins += 1
	times_pin_was_bought += 1
	pin_price += times_pin_was_bought
	refresh_price_tags()

func _on_more_hp_pressed() -> void:
	StatManagerGlobal.coins -= hp_price
	StatManagerGlobal.hp += 1
	times_hp_where_bought += 1
	hp_price += times_hp_where_bought
	refresh_price_tags()

func _on_more_collection_time_pressed() -> void:
	StatManagerGlobal.coins -= collection_time_price
	StatManagerGlobal.additional_time += 1
	times_collection_time_was_bought += 1
	collection_time_price += times_collection_time_was_bought
	refresh_price_tags()

func _on_buy_shield_pressed() -> void:
	StatManagerGlobal.coins -= shield_price
	StatManagerGlobal.shield_pieces += 1
	times_shield_was_bought += 1
	shield_price += 5
	refresh_price_tags()
	get_tree().get_first_node_in_group("Player").add_shield()

func _on_buy_slushie_pressed() -> void:
	StatManagerGlobal.coins -= slushie_price
	StatManagerGlobal.slushies += 1
	times_slushie_was_bought += 1
	slushie_price += 10
	refresh_price_tags()
