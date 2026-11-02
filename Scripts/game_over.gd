extends Control
class_name GameOver

@onready var death_cause_label: Label = $VBoxContainer/DeathCauseLabel

var death_cause: String = "":
	set(new_text):
		death_cause = new_text
		death_cause_label.text = death_cause

func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()
