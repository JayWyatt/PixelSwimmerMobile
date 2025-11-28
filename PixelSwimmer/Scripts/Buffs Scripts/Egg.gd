class_name Egg
extends Buffs

@export var levelcompleted_text_scene: PackedScene

func _on_body_entered(body):
	if not body.is_in_group("player"):
		return

	# 🔒 IMMEDIATELY make player safe (THIS is the critical line)
	body.can_die = false
	body.set_physics_process(false)
	body.set_process(false)

	# Optional: stop movement instantly
	if body.has_method("stop_movement"):
		body.stop_movement()

	# Level completion logic
	body.completed_level()
	show_levelcompleted_text(body)

	var main = get_tree().current_scene
	main._check_level_completion()

	picked_up.emit(buff_sound)
	queue_free()

func show_levelcompleted_text(player: Node) -> void:
	var popup = levelcompleted_text_scene.instantiate()
	player.get_node("TextAnchor").add_child(popup)
	popup.position = Vector2.ZERO  # centered on anchor
	popup.show_text()
