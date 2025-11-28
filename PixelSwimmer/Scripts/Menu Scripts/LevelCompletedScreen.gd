extends Node2D

signal next_level_pressed

func _on_next_level_pressed() -> void:
	get_tree().paused = false
	emit_signal("next_level_pressed")
	Input.vibrate_handheld(40, 0.3)

func _on_main_menu_pressed() -> void:
	SceneHelper._deferred_change_scene.call_deferred("res://Scenes/Menu Scenes/main_menu.tscn")
