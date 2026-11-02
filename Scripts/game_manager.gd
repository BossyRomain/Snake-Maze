extends Node

@export var snake: Snake

@export_group("Menus")
@export var hud: HUD

func _ready() -> void:
	await get_tree().create_timer(0.01).timeout
	var apples = get_tree().get_nodes_in_group("Apples")
	for apple in apples:
		apple.eaten.connect(_on_apple_eaten)
	
	var chickens = get_tree().get_nodes_in_group("Chickens")
	for chicken in chickens:
		snake.moved.connect(chicken.move)
	
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
