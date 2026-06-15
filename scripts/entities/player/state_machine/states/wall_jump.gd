class_name PlayerWallJumpState extends PlayerState

@export var jump_velocity: float = 400.0
@export var horizontal_push: float = 250.0
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var speed: float = 200
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var acceleration: float = 8
@export var ground_slam_time : float = 0.1

var wall_normal: Vector2

func init():
	pass

func enter():
	wall_normal = player.get_wall_normal()
	player.velocity.x = wall_normal.x * horizontal_push
	player.velocity.y = -jump_velocity
	player.anim_player.play("Jump")
	player.rotation = 0

func exit():
	pass

func handle_input( _event: InputEvent ) -> PlayerState:
	if _event.is_action_pressed("GroundSlam"):
		if player.ground_slam_timer.is_stopped():
			player.ground_slam_timer.start(ground_slam_time)
		else:
			player.ground_slam_timer.stop()
			return ground_slam
	if _event.is_action_pressed("Dash"):
		return dash
	if _event.is_action_released("Jump"):
		player.velocity.y *= 0.5
		return fall
	return null

func process(_delta: float) -> PlayerState:
	return null

func physics_process(_delta: float) -> PlayerState:
	player.update_animation_direction()
	
	var target_vel = direction.x * speed
	
	if abs(player.velocity.x) > speed and direction.x != 0:
		target_vel = player.velocity.x
	if direction.x != 0 and sign(direction.x) == sign(player.velocity.x) and abs(player.velocity.x) > speed:
		target_vel = player.velocity.x
	player.update_velocity(target_vel, acceleration)
	
	if player.is_on_floor():
		return idle
	elif player.velocity.y >= 0:
		return fall
	return null
