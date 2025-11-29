extends Control

func _ready() -> void:
	print("[AdScreen] connecting rewarded_ad_finished") 
	WatchAd.reset()
	WatchAd.rewarded_ad_finished.connect(_on_rewarded_ad_finished)
	
	print(
	"[AdScreen] is connected:",
	WatchAd.rewarded_ad_finished.is_connected(_on_rewarded_ad_finished)
	)

func _on_rewarded_ad_finished(success: bool) -> void:
	print("[AdScreen] received rewarded_ad_finished:", success)
	if success:
		SceneHelper._deferred_change_scene.call_deferred("res://Scenes/Menu Scenes/game_over_screen.tscn")
