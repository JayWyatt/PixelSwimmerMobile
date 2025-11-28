extends Node2D



func _on_story_mode_pressed() -> void:
	get_tree().paused = false
	MusicManager.play_menu_music()
	SceneHelper._deferred_change_scene.call_deferred("res://Scenes/Menu Scenes/ChaptersScreen.tscn")


func _on_main_menu_pressed() -> void:
	SceneHelper._deferred_change_scene.call_deferred("res://Scenes/Menu Scenes/main_menu.tscn")
