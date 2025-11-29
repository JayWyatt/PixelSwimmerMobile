extends Node2D

@onready var admob := $AdMob
@onready var watch_button := $WatchAdButton
var rewarded_loaded := false

func _ready() -> void:
	if OS.has_feature("android"):
		admob.initialize()
	else:
		print("[AD] NOT ANDROID")

func _on_ad_mob_initialization_completed(_status_data) -> void:
	admob.load_rewarded_ad()

func _on_ad_mob_rewarded_ad_loaded() -> void:
	rewarded_loaded = true

func _on_ad_mob_rewarded_ad_user_earned_reward(_ad_id: String, _reward_data: RewardItem) -> void:
	print("[ADMOB] USER EARNED REWARD")
	WatchAd.on_user_earned_reward()
	rewarded_loaded = false
	admob.load_rewarded_ad()

func _on_ad_mob_rewarded_ad_failed_to_load() -> void:
	rewarded_loaded = false

func _on_watch_ad_button_pressed() -> void:
	admob.show_rewarded_ad()

func _on_ad_mob_rewarded_ad_closed() -> void:
	if not WatchAd.was_rewarded:
		WatchAd.on_ad_closed_without_reward()
