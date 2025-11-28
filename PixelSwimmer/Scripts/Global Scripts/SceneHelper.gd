extends Node

func _deferred_change_scene(path: String) -> void:
	Input.vibrate_handheld(40, 0.3)
	get_tree().change_scene_to_file(path)
