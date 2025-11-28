extends Control

@onready var score = $Score:
	set(value):
		score.text = "Score: " + str(value)

func hide_score():
	$Score.hide()

func show_score():
	$Score.show()

func set_level_text(text: String):
	$LevelLabel.text = text

func show_level_for_seconds(text: String, duration: float = 3.0) -> void:
	$LevelLabel.text = text
	$LevelLabel.show()
	await get_tree().create_timer(duration).timeout
	$LevelLabel.hide()

	# Wait for the given duration
	await get_tree().create_timer(duration).timeout

	# Hide it afterwards
	$LevelLabel.hide()
