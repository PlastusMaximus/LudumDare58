class_name EndlessMode extends Level

const ENEMY: PackedScene = preload("uid://dyms4wvgonf18")

@onready var time_limit: Timer = $TimeLimit

func _ready() -> void:
	super._ready()
	time_limit.timeout.connect(_on_time_limit_timeout)
	_spawn_enemies()

func next_endless_mode_wave() -> void:
	StatManagerGlobal.endless_mode_wave += 1
	time_limit.wait_time +=  5
	easy_enemies += StatManagerGlobal.endless_mode_wave
	medium_enemies += StatManagerGlobal.endless_mode_wave
	hard_enemies += StatManagerGlobal.endless_mode_wave
	GameManagerGlobal.unfreeze_enemies_in_endless_mode()
	_spawn_enemies()
	time_limit.start()
	
func _spawn_enemies() -> void:
	for i: int in range(0, easy_enemies):
		var enemy: Enemy = ENEMY.instantiate()
		enemy.movement = randi_range(0,2)
		enemy.difficulty = Enemy.Difficulty.EASY
		enemies.add_child(enemy)
			
	for i: int in range(0, medium_enemies):
		var enemy: Enemy = ENEMY.instantiate()
		enemy.movement = randi_range(0,2)
		enemy.difficulty = Enemy.Difficulty.MEDIUM
		enemies.add_child(enemy)
		
	for i: int in range(0, hard_enemies):
		var enemy: Enemy = ENEMY.instantiate()
		enemy.movement = randi_range(0,2)
		enemy.difficulty = Enemy.Difficulty.HARD
		enemies.add_child(enemy)

func _on_time_limit_timeout() -> void:
	GameManagerGlobal.open_shop_in_endless_mode()
	GameManagerGlobal.freeze_enemies_in_endless_mode()
	await GameManagerGlobal.shop.shop_closed
	GameManagerGlobal.shop_open = false
	next_endless_mode_wave()
	
	
