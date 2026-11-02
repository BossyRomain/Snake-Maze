extends Control
class_name HUD

@onready var snake_length_label: Label = $HBoxContainer/SnakeLengthLabel
@onready var apples_eaten_label: Label = $HBoxContainer/ApplesEatenLabel
@onready var total_apples_label: Label = $HBoxContainer/TotalApplesLabel

var apples_eaten: int = 0:
	set(new_value):
		apples_eaten = new_value
		apples_eaten_label.text = str(apples_eaten)

var total_apples: int = 0:
	set(new_value):
		total_apples = new_value
		total_apples_label.text = str(total_apples)

var snake_length: int = 0:
	set(new_value):
		snake_length = new_value
		snake_length_label.text = str(snake_length)
