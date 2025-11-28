extends Node2D




func _on_back_pressed() -> void:
	SceneHelper._deferred_change_scene.call_deferred("res://Scenes/Menu Scenes/ChaptersScreen.tscn")


func _on_main_menu_pressed() -> void:
	SceneHelper._deferred_change_scene.call_deferred("res://Scenes/Menu Scenes/main_menu.tscn")
