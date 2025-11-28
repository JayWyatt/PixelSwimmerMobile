extends Node

@onready var loading_screen_scene: PackedScene = preload("res://Scenes/Menu Scenes/LoadingScreen.tscn")

var scene_to_load_path: String = ""
var loading_screen_scene_instance: Control
var loading: bool = false

func _ready() -> void:
	set_process(true)

func load_scene(path: String) -> void:
	if loading:
		return

	scene_to_load_path = path
	loading = true

	# Vibrate on click
	Input.vibrate_handheld(40, 0.3)

	# Show loading screen
	loading_screen_scene_instance = loading_screen_scene.instantiate()
	get_tree().root.call_deferred("add_child", loading_screen_scene_instance)

	# Start threaded loading
	var err := ResourceLoader.load_threaded_request(path)
	if err != OK:
		print("Failed to start threaded load: ", err)
		loading = false

func _process(_delta: float) -> void:
	if not loading:
		return

	var progress: Array = []
	var status := ResourceLoader.load_threaded_get_status(scene_to_load_path, progress)

	if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		if is_instance_valid(loading_screen_scene_instance):
			var bar: ProgressBar = loading_screen_scene_instance.get_node("ProgressBar")
			if progress.size() > 0:
				bar.value = progress[0] * 100.0
	elif status == ResourceLoader.THREAD_LOAD_LOADED:
		var packed: PackedScene = ResourceLoader.load_threaded_get(scene_to_load_path)
		if packed:
			get_tree().change_scene_to_packed(packed)
		else:
			print("Loaded resource is null for: ", scene_to_load_path)

		if is_instance_valid(loading_screen_scene_instance):
			loading_screen_scene_instance.queue_free()

		loading = false
		scene_to_load_path = ""
	elif status == ResourceLoader.THREAD_LOAD_FAILED:
		print("Threaded load failed for: ", scene_to_load_path)
		loading = false
