extends Control

func set_score(value):
	$Panel/Score.text = "Score:  " + str(value)

func set_high_score(value):
	$"Panel/HighScore".text = "High Score: " + str(value)

#try again button
func _on_texture_button_pressed() -> void:
	SceneHelper._deferred_change_scene.call_deferred("res://Scenes/Root.tscn")

func _on_revive_pressed() -> void:
	if WatchAd.was_rewarded:
		# Reward already earned → revive immediately
		SceneHelper._deferred_change_scene.call_deferred("res://Scenes/Root.tscn")
	else:
		# No reward → go watch ad
		SceneHelper._deferred_change_scene.call_deferred("res://Scenes/AdVert Scenes/AdScreen.tscn")
