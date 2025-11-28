extends Node2D
	
func _on_try_again_pressed() -> void:
	get_tree().paused = false     # <-- FIX
	SceneHelper._deferred_change_scene.call_deferred("res://Scenes/Root.tscn")


func _on_main_menu_pressed() -> void:
	get_tree().paused = false     # <-- FIX
	SceneHelper._deferred_change_scene.call_deferred("res://Scenes/Menu Scenes/main_menu.tscn")
