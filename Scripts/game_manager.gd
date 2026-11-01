extends Node

@export var snake: Snake

func _ready() -> void:
	await get_tree().create_timer(0.01).timeout
	var apples = get_tree().get_nodes_in_group("Apples")
	for apple in apples:
		apple.eaten.connect(_on_apple_eaten)

func _on_apple_eaten(type: Apple.Type):
	var grow_size = 1
	var double_moves_left = 0
	if type == Apple.Type.GREEN:
		grow_size = 2
	elif type == Apple.Type.GOLDEN:
		double_moves_left = 2
	snake.double_moves_left = double_moves_left
	snake.grow(grow_size)
