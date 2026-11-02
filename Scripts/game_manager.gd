extends Node

@export var snake: Snake

@export_group("Menus")
@export var hud: HUD
@export var game_over: GameOver
@export var win: Win

func _ready() -> void:
	game_over.visible = false
	win.visible = false
	
	await get_tree().create_timer(0.01).timeout
	var apples = get_tree().get_nodes_in_group("Apples")
	for apple in apples:
		apple.eaten.connect(_on_apple_eaten)
	
	var chickens = get_tree().get_nodes_in_group("Chickens")
	for chicken in chickens:
		chicken.snake_bitten.connect(_on_chicken_bite_snake)
		snake.moved.connect(chicken.move)
	
	snake.moved.connect(_on_snake_moved)
	
	hud.apples_eaten = 0
	hud.total_apples = apples.size()
	hud.snake_length = snake.body.size()

func _on_apple_eaten(type: Apple.Type):
	var grow_size = 1
	var double_moves_left = 0
	if type == Apple.Type.GREEN:
		grow_size = 2
	elif type == Apple.Type.GOLDEN:
		double_moves_left = 2
	snake.double_moves_left = double_moves_left
	snake.grow(grow_size)
	hud.snake_length += grow_size
	hud.apples_eaten += 1
	
	if hud.apples_eaten == hud.total_apples:
		_win()

func _on_snake_moved(head_pos: Vector2):
	if _does_snake_bite_itself(head_pos):
		_game_over("You bite yourself")

func _does_snake_bite_itself(snake_head_pos: Vector2) -> bool:
	for i in range(1, snake.body.size()):
		if snake_head_pos == snake.body[i].global_position:
			return true
	return false

func _on_chicken_bite_snake():
	_game_over("A chicken has bitten your head")

func _game_over(death_cause: String):
	snake.process_mode = Node.PROCESS_MODE_DISABLED
	game_over.death_cause = death_cause
	game_over.visible = true

func _win():
	snake.process_mode = Node.PROCESS_MODE_DISABLED
	win.visible = true
