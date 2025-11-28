extends Node2D

@onready var level_2: TextureButton = $Buttons/Level2
@onready var level_3: TextureButton = $Buttons/Level3
@onready var level_4: TextureButton = $Buttons/Level4
@onready var level_5: TextureButton = $Buttons/Level5
@onready var level_6: TextureButton = $Buttons/Level6
@onready var level_7: TextureButton = $Buttons/Level7
@onready var level_8: TextureButton = $Buttons/Level8
@onready var level_9: TextureButton = $Buttons/Level9
@onready var boss_level: TextureButton = $Buttons/BossLevel



func _ready() -> void:
	# Lock level 2 if highest_unlocked_level < 1
	level_2.disabled = GameSession.highest_unlocked_level < 1
	level_3.disabled = GameSession.highest_unlocked_level < 2
	level_4.disabled = GameSession.highest_unlocked_level < 3
	level_5.disabled = GameSession.highest_unlocked_level < 4
	level_6.disabled = GameSession.highest_unlocked_level < 5
	level_7.disabled = GameSession.highest_unlocked_level < 6
	level_8.disabled = GameSession.highest_unlocked_level < 7
	level_9.disabled = GameSession.highest_unlocked_level < 8
	boss_level.disabled = GameSession.highest_unlocked_level < 9
	
func _on_level_1_pressed() -> void:
	if 0 > GameSession.highest_unlocked_level:
		return
	GameSession.mode = "story"
	GameSession.current_level = 0
	SceneLoader.load_scene("res://Scenes/Root.tscn")

func _on_level_2_pressed() -> void:
	Input.vibrate_handheld(40, 0.3)
	if 1 > GameSession.highest_unlocked_level:
		return
	GameSession.mode = "story"
	GameSession.current_level = 1
	SceneLoader.load_scene("res://Scenes/Root.tscn")

func _on_level_3_pressed() -> void:
	Input.vibrate_handheld(40, 0.3)
	if 2 > GameSession.highest_unlocked_level:
		return
	GameSession.mode = "story"
	GameSession.current_level = 2
	SceneLoader.load_scene("res://Scenes/Root.tscn")

func _on_level_4_pressed() -> void:
	Input.vibrate_handheld(40, 0.3)
	if 3 > GameSession.highest_unlocked_level:
		return
	GameSession.mode = "story"
	GameSession.current_level = 3
	SceneLoader.load_scene("res://Scenes/Root.tscn")

func _on_level_5_pressed() -> void:
	Input.vibrate_handheld(40, 0.3)
	if 4 > GameSession.highest_unlocked_level:
		return
	GameSession.mode = "story"
	GameSession.current_level = 4
	SceneLoader.load_scene("res://Scenes/Root.tscn")

func _on_level_6_pressed() -> void:
	Input.vibrate_handheld(40, 0.3)
	if 5 > GameSession.highest_unlocked_level:
		return
	GameSession.mode = "story"
	GameSession.current_level = 5
	SceneLoader.load_scene("res://Scenes/Root.tscn")

func _on_level_7_pressed() -> void:
	Input.vibrate_handheld(40, 0.3)
	if 6 > GameSession.highest_unlocked_level:
		return
	GameSession.mode = "story"
	GameSession.current_level = 6
	SceneLoader.load_scene("res://Scenes/Root.tscn")

func _on_level_8_pressed() -> void:
	Input.vibrate_handheld(40, 0.3)
	if 7 > GameSession.highest_unlocked_level:
		return
	GameSession.mode = "story"
	GameSession.current_level = 7
	SceneLoader.load_scene("res://Scenes/Root.tscn")

func _on_level_9_pressed() -> void:
	Input.vibrate_handheld(40, 0.3)
	if 8 > GameSession.highest_unlocked_level:
		return
	GameSession.mode = "story"
	GameSession.current_level = 8
	SceneLoader.load_scene("res://Scenes/Root.tscn")

func _on_boss_level_pressed() -> void:
	Input.vibrate_handheld(40, 0.3)
	if 9 > GameSession.highest_unlocked_level:
		return
	GameSession.mode = "story"
	GameSession.current_level = 9
	SceneLoader.load_scene("res://Scenes/Root.tscn")

func _on_back_button_pressed() -> void:
	Input.vibrate_handheld(40, 0.3)
	SceneHelper._deferred_change_scene.call_deferred("res://Scenes/Menu Scenes/ChaptersScreen.tscn")
