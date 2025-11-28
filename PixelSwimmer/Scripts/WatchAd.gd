extends Node2D

@onready var admob := $AdMob
@onready var watch_button := $WatchAdButton
var rewarded_loaded := false

func _ready() -> void:
	if OS.has_feature("android"):
		print("[AD] ANDROID: initializing")
		admob.initialize()
	else:
		print("[AD] NOT ANDROID")

func _on_ad_mob_initialization_completed(status_data: InitializationStatus) -> void:
	print("[AD] initialization completed: ", status_data)
	admob.load_rewarded_ad()
	print("[AD] called load_rewarded_ad")

func _on_ad_mob_rewarded_ad_loaded(ad_id: String, _response_info: ResponseInfo) -> void:
	rewarded_loaded = true
	print("[AD] Rewarded ad loaded for ad_id:", ad_id)

func _on_ad_mob_rewarded_ad_user_earned_reward(ad_id: String, reward_data: RewardItem) -> void:
	print("[AD] Reward from ad: ", ad_id, " type:", reward_data.type, " amount:", reward_data.amount)
	rewarded_loaded = false
	admob.load_rewarded_ad()

func _on_ad_mob_rewarded_ad_failed_to_load(ad_id: String, error_data: LoadAdError) -> void:
	rewarded_loaded = false
	print("[AD] rewarded failed, ad_id: ", ad_id, " code: ", error_data.code, " msg: ", error_data.message)

func _on_watch_ad_button_pressed() -> void:
	print("[AD] Watch button pressed")
	if not rewarded_loaded:
		print("[AD] Rewarded not ready yet")
		return
	print("[AD] Showing rewarded")
	admob.show_rewarded_ad()
