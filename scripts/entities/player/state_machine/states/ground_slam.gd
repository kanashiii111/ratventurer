class_name PlayerGroundSlamState extends PlayerState

@export var ground_slam_speed : float = 700
const SLAM_EFFECT = preload("res://scenes/entities/player/slam_effect.tscn")

@export var shake_intensity: float = 4.0
@export var shake_duration: float = 0.15

@export var slam_audio: AudioStream

var prev_collision_layer: int

func init():
	pass

func enter():
	player.anim_player.play("GroundSlam")
	prev_collision_layer = player.collision_layer
	player.collision_layer = 1
	player.velocity.y = ground_slam_speed
	player.rotation = 0

func exit():
	player.play_sfx(slam_audio)
	player.collision_layer = prev_collision_layer
	for body in player.ground_slam_hitbox.get_overlapping_bodies():
		if body is Skeleton:
			body.die()

func handle_input( _event: InputEvent ) -> PlayerState:
	if _event.is_action_pressed("Dash"):
		if not player.has_dash:
			return null
		player.has_dash = false
		return dash
	return null

func process(_delta: float) -> PlayerState:
	return null

func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = 0
	
	if player.is_on_floor():
		if player.get_floor_normal().x != 0:
			var normal = player.get_floor_normal()
			var downhill = Vector2.DOWN.slide(normal).normalized()
			player.velocity = downhill * ground_slam_speed / 4
			player.velocity.y = max(player.velocity.y, 0)
			return slide
		spawn_slam_effect()
		return idle
	return null

func spawn_slam_effect():
	var feet_y = -3

	var right = SLAM_EFFECT.instantiate()
	right.position = Vector2(24, feet_y)
	player.add_child(right)

	var left = SLAM_EFFECT.instantiate()
	left.position = Vector2(-24, feet_y)
	left.scale.x = -1
	player.add_child(left)
	
	var camera := player.get_node("camera") as Camera2D
	if not camera:
		return

	var original_offset := camera.offset
	var tween := create_tween()
	tween.tween_method(
		func(amplitude: float):
			camera.offset = original_offset + Vector2(
				randf_range(-amplitude, amplitude),
				randf_range(-amplitude, amplitude)
			),
		shake_intensity, 0.0, shake_duration
	)
	tween.tween_callback(func():
		camera.offset = original_offset
	)
