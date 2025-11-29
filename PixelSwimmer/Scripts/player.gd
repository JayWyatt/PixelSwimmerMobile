class_name Player
extends CharacterBody2D

# ───────────────────────────────────────────────
# Signals
# ───────────────────────────────────────────────
signal laser_shot(laser_scene, location, shooter)
signal killed
signal hit
signal levelcompleted

# ───────────────────────────────────────────────
# MOBILE INPUT
# ───────────────────────────────────────────────
@export var drag_threshold: float = 8          # how far you must move before it's a drag
@export var shoot_cooldown: float = 0.12       # seconds between shots
@export var max_drag_distance: float = 120
@export var follow_strength: float = 10

var touch_start_pos: Vector2 = Vector2.ZERO
var is_dragging: bool = false
var touch_was_movement: bool = false
var move_direction: Vector2 = Vector2.ZERO
var last_shot_time: float = 0.0
var finger_pos: Vector2 = Vector2.ZERO
var speed_multiplyer = 1.0

# New: offset so player is not under the thumb
var drag_offset: Vector2 = Vector2.ZERO

# ───────────────────────────────────────────────
# Export variables
# ───────────────────────────────────────────────
@export var SPEED := 300.0
@export var SHOOT_MULTIPLIER := 1.3
@export var margin := 32

# Laser variables
@export var base_laser_damage = 1
var laser_damage_multiplier := 1.0
var laser_scene := preload("res://Scenes/Laser Scenes/Laser.tscn")
@export var damage_buff_laser_scene := preload("res://Scenes/Laser Scenes/DamageBuffLaser.tscn")

var buff_active = false
var is_slowed := false

# HP + UI
@export var max_hp := 10
@export var hp: int = 3

var red_hearts_list: Array[TextureRect] = []
var black_hearts_list: Array[TextureRect] = []
var blue_hearts_list: Array[TextureRect] = []

# Variables
var can_heal: bool = true
var is_poisoned: bool = false
var has_shield: bool = false
var shield_time_left: float = 0.0
var has_damage_buff: bool = false
var damage_time_left: float = 0.0
var level_completed: bool = false
var is_vulnerable = true
var is_dead = false

# ───────────────────────────────────────────────
# Node References
# ───────────────────────────────────────────────
@onready var muzzle: Node2D = $Muzzle
@onready var red_hearts := $health_bar/RedHearts
@onready var black_hearts := $health_bar/BlackHearts
@onready var blue_hearts := $health_bar/BlueHearts
@onready var damage_sfx := $TakeDamage
@onready var low_health_sfx := $LowHealth

# ───────────────────────────────────────────────
# MOBILE INPUT
# ───────────────────────────────────────────────
func _input(event):
	# TOUCH START
	if event is InputEventScreenTouch and event.pressed:
		touch_start_pos = event.position
		is_dragging = true
		touch_was_movement = false
		move_direction = Vector2.ZERO

		# Option A: use the real offset between player and finger
		# drag_offset = global_position - event.position

		# Option B: force the player to always sit above the thumb (recommended)
		drag_offset = Vector2(0, -60)  # adjust 80 to how far above the thumb you want the player

		# also set initial finger position
		finger_pos = event.position

	# DRAG → MOVEMENT
	elif event is InputEventScreenDrag and is_dragging:
		var drag_vector: Vector2 = event.position - touch_start_pos

		if drag_vector.length() > drag_threshold:
			touch_was_movement = true
			finger_pos = event.position

	# TOUCH RELEASE → POSSIBLE TAP / SHOOT
	elif event is InputEventScreenTouch and not event.pressed:
		is_dragging = false
		move_direction = Vector2.ZERO
		velocity = Vector2.ZERO

		# If this touch wasn't a movement, treat it as a tap
		if not touch_was_movement:
			var now: float = Time.get_ticks_msec() / 1000.0
			if now - last_shot_time >= shoot_cooldown:
				shoot()
				last_shot_time = now

# ───────────────────────────────────────────────
# MOVEMENT
# ───────────────────────────────────────────────
func _physics_process(delta):
	# Smooth movement while dragging
	if is_dragging:
		# desired position keeps a fixed offset from the finger
		var desired_pos: Vector2 = finger_pos + drag_offset
		var to_target: Vector2 = desired_pos - global_position

		var distance := to_target.length()
		if distance > max_drag_distance:
			to_target = to_target.normalized() * max_drag_distance

		velocity = to_target * follow_strength * speed_multiplyer
	else:
		# friction / slow down when not dragging
		velocity = velocity.move_toward(Vector2.ZERO, SPEED * delta)

	move_and_slide()

	# Clamp AFTER move_and_slide so we keep collisions
	var screen_size: Vector2 = get_viewport_rect().size
	var half_height: float = screen_size.y * 0.5

	global_position.x = clamp(global_position.x, margin, screen_size.x - margin)
	global_position.y = clamp(global_position.y, half_height + margin, screen_size.y - margin)

# ───────────────────────────────────────────────
# SHOOTING
# ───────────────────────────────────────────────
func shoot():
	var location: Vector2 = muzzle.global_position

	var scene_to_fire = laser_scene
	if has_damage_buff:
		scene_to_fire = damage_buff_laser_scene

	laser_shot.emit(scene_to_fire, location, self)

func _process(delta):
	# Shield timer
	if has_shield:
		shield_time_left -= delta
		if shield_time_left <= 0.0:
			shield_time_left = 0.0
			has_shield = false
			update_heart_display()

	# Damage buff timer
	if has_damage_buff:
		damage_time_left -= delta
		if damage_time_left <= 0.0:
			damage_time_left = 0.0
			has_damage_buff = false

# ───────────────────────────────────────────────
# READY
# ───────────────────────────────────────────────
func _ready():
	# Load heart UI into list
	for heart in red_hearts.get_children():
		if heart is TextureRect:
			red_hearts_list.append(heart)

	for heart in black_hearts.get_children():
		if heart is TextureRect:
			black_hearts_list.append(heart)

	for heart in blue_hearts.get_children():
		if heart is TextureRect:
			blue_hearts_list.append(heart)

	# Ensure display matches hp
	update_heart_display()

# ───────────────────────────────────────────────
# SLOW EFFECT
# ───────────────────────────────────────────────
func apply_slow(amount: float, duration: float):
	if is_slowed:
		return

	is_slowed = true
	speed_multiplyer *= amount

	var timer := get_tree().create_timer(duration)
	timer.timeout.connect(func():
		if is_instance_valid(self):
			speed_multiplyer /= amount
			is_slowed = false)

# ───────────────────────────────────────────────
# UPDATE HEART UI
# ───────────────────────────────────────────────
func update_heart_display():
	for i in range(max_hp):
		if has_shield:
			# Show blue hearts
			blue_hearts_list[i].visible = i < hp
			red_hearts_list[i].visible = false
			black_hearts_list[i].visible = false

		elif is_poisoned:
			# Show black hearts
			black_hearts_list[i].visible = i < hp
			red_hearts_list[i].visible = false
			blue_hearts_list[i].visible = false

		else:
			# Show red hearts
			red_hearts_list[i].visible = i < hp
			black_hearts_list[i].visible = false
			blue_hearts_list[i].visible = false

# Low HP alert
func low_health_alert():
	if hp == 1:
		if low_health_sfx and not low_health_sfx.is_playing():
			low_health_sfx.play()
	elif hp > 1:
		if low_health_sfx and low_health_sfx.is_playing():
			low_health_sfx.stop()

# ───────────────────────────────────────────────
# DAMAGE + DEATH
# ───────────────────────────────────────────────
func take_damage(amount: int):
	if has_shield or not is_vulnerable or is_dead:
		return

	hp -= amount

	if hp <= 0:
		hp = 0
		is_vulnerable = false
		die()
		return

	# Only play damage sound if still alive
	damage_sfx.play()

	# Still alive:
	low_health_alert()
	update_heart_display()
	hit.emit()

func die():
	if is_dead:
		return
	
	is_dead = true
	killed.emit()
	queue_free()

# Healing
func heal(amount: int):
	if is_poisoned:
		return

	hp = clamp(hp + amount, 0, max_hp)
	update_heart_display()
	low_health_alert()

func apply_poison():
	if has_shield:
		return
	is_poisoned = true
	update_heart_display()

func cure_poison():
	is_poisoned = false
	update_heart_display()

func apply_shield(duration):
	if is_poisoned:
		return
	has_shield = true
	shield_time_left = duration
	update_heart_display()

func apply_damage_buff(duration):
	if has_damage_buff:
		return
	has_damage_buff = true
	damage_time_left = duration

func completed_level():
	level_completed = true
	emit_signal("levelcompleted")

# ───────────────────────────────────────────────
# COLLISION WITH ENEMY
# ───────────────────────────────────────────────
func _on_body_entered(body):
	if body is Enemy:
		body.take_damage(1, self)
		take_damage(1)

func _on_hit() -> void:
	$"../SFX/EnemyHit".play()

func get_save_data() -> Dictionary:
	return {
		"position": global_position,
		"hp": hp,
		# score is managed in root/autoload, not here
	}
