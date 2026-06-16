class_name PlayerGroundSlamState extends PlayerState

@export var ground_slam_speed : float = 1000
const SLAM_EFFECT = preload("res://scenes/entities/player/slam_effect.tscn")

var prev_collision_layer: int

func init():
	pass

func enter():
	#player.anim_player.play("GroundSlam")
	prev_collision_layer = player.collision_layer
	player.collision_layer = 1
	player.velocity.y = ground_slam_speed
	player.rotation = 0

func exit():
	player.collision_layer = prev_collision_layer
	for body in player.ground_slam_hitbox.get_overlapping_bodies():
		if body is Skeleton:
			body.die()

func handle_input( _event: InputEvent ) -> PlayerState:
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
