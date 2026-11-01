extends Area2D
class_name Apple

enum Type {
	RED,
	GREEN,
	GOLDEN,
}

signal eaten(Type)

@export var type: Type

func _on_area_entered(area: Area2D) -> void:
	eaten.emit(type)
	queue_free()
