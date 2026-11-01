extends Area2D
class_name Chicken

const TILE_SIZE: int = 16

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

func move(snake_head_pos: Vector2):
	navigation_agent_2d.target_position = snake_head_pos
	var target_pos = navigation_agent_2d.get_next_path_position()
	var dir = (target_pos - position).normalized().round()
	position += dir * TILE_SIZE
