extends Node2D
class_name Snake

const TILE_SIZE: int = 16

@export var prev_dir: Vector2

var body: Array[Area2D]
var double_moves_left: int = 0

func _ready() -> void:
	for child in get_children():
		if is_instance_of(child, Area2D):
			body.append(child)
	_update_body_sprites(prev_dir)
	body[0].collision_layer = 2

func _input(event: InputEvent) -> void:
	var dir = Vector2.ZERO
	if event.is_action_pressed("move_up") and prev_dir != Vector2.DOWN:
		dir = Vector2.UP
	elif event.is_action_pressed("move_down") and prev_dir != Vector2.UP:
		dir = Vector2.DOWN
	elif event.is_action_pressed("move_left") and prev_dir != Vector2.RIGHT:
		dir = Vector2.LEFT
	elif event.is_action_pressed("move_right") and prev_dir != Vector2.LEFT:
		dir = Vector2.RIGHT
	
	if dir != Vector2.ZERO and _can_move(dir):
		_move(dir)
		if double_moves_left > 0 and _can_move(dir):
			_move(dir)
		double_moves_left = max(0, double_moves_left - 1)
		_update_body_sprites(dir)

func grow(grow_size: int):
	var body_scene = load("res://Scenes/Snake/snake_body.tscn")
	for i in range(grow_size):
		var new_part = body_scene.instantiate()
		new_part.position = body[-1].position
		new_part.get_node("Sprite2D").region_rect.position = Vector2(-1, 0) * TILE_SIZE  
		add_child(new_part)
		body.append(new_part)

func _can_move(dir: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var head_pos = body[0].global_position
	var query = PhysicsRayQueryParameters2D.create(head_pos, head_pos + dir * TILE_SIZE)
	var result = space_state.intersect_ray(query)
	return result.is_empty() or result.collider == null

func _move(dir: Vector2):
	prev_dir = dir
	var new_position = body[0].position + dir * TILE_SIZE
	for part in body:
		var old_position = part.position
		part.position = new_position
		new_position = old_position

func _update_body_sprites(dir: Vector2):
	_update_head_sprite(dir)
	var tail_prev_part = null
	for i in range(1, body.size() - 1):
		var part = body[i]
		if part.position != body[-1].position:
			tail_prev_part = part
			_update_body_part_sprite(body[i - 1], part, body[i + 1])
	_update_tail_sprite(tail_prev_part)

func _update_head_sprite(dir: Vector2):
	var head = body[0]
	var index = 0
	match dir:
		Vector2.UP:
			index = 1
		Vector2.DOWN:
			index = 0
		Vector2.LEFT:
			index = 2
		Vector2.RIGHT:
			index = 3
	head.get_node("Sprite2D").region_rect.position = TILE_SIZE * Vector2.RIGHT * index

func _update_body_part_sprite(prev: Area2D, part: Area2D, next: Area2D):
	var delta = (prev.position - next.position).normalized().round()
	var x_index = 0
	var y_index = 0
	if delta.x == 0 || delta.y == 0:
		y_index = 3
		match delta:
			Vector2.UP:
				x_index = 0
			Vector2.DOWN:
				x_index = 0
			Vector2.LEFT:
				x_index = 1
			Vector2.RIGHT:
				x_index = 1
	else:
		y_index = 1
		var dir = (prev.position - part.position).normalized().round()
		match [delta, dir]:
			[Vector2(-1, -1), Vector2.LEFT]:
				x_index = 3
			[Vector2(-1, -1), Vector2.UP]:
				x_index = 0
			[Vector2(1, -1), Vector2.RIGHT]:
				x_index = 2
			[Vector2(1, -1), Vector2.UP]:
				x_index = 1
			[Vector2(-1, 1), Vector2.LEFT]:
				x_index = 1
			[Vector2(-1, 1), Vector2.DOWN]:
				x_index = 2
			[Vector2(1, 1), Vector2.RIGHT]:
				x_index = 0
			[Vector2(1, 1), Vector2.DOWN]:
				x_index = 3
	part.get_node("Sprite2D").region_rect.position = TILE_SIZE * Vector2.RIGHT * x_index + Vector2.DOWN * TILE_SIZE * y_index

func _update_tail_sprite(prev_part: Area2D):
	var tail = body[-1]
	var delta = (prev_part.position - tail.position).normalized().round()
	var index = 0
	match delta:
		Vector2.UP:
			index = 3
		Vector2.DOWN:
			index = 2
		Vector2.LEFT:
			index = 1
		Vector2.RIGHT:
			index = 0
	tail.get_node("Sprite2D").region_rect.position = TILE_SIZE * Vector2.RIGHT * index + 2 * Vector2.DOWN * TILE_SIZE
