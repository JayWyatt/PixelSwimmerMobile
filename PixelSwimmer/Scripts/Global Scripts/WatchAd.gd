extends Node

signal rewarded_ad_finished(success: bool)

var was_rewarded: bool = false

func on_user_earned_reward() -> void:
	print("[WatchAd] emitting rewarded_ad_finished(TRUE)")
	was_rewarded = true
	rewarded_ad_finished.emit(true)

func on_ad_closed_without_reward() -> void:
	print("[WatchAd] emitting rewarded_ad_finished(FALSE)")
	was_rewarded = false
	rewarded_ad_finished.emit(false)

func reset():
	was_rewarded = false
