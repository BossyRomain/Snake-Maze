extends Control
class_name Win

@export var next_level: String

func _on_next_level_button_pressed() -> void:
	get_tree().change_scene_to_file(next_level)
