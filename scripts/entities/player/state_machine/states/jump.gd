class_name PlayerJumpState extends PlayerState

@export var jump_velocity : float = 350.0
@export_custom( PROPERTY_HINT_NONE, "suffix:px/s" ) var speed: float = 200
@export_custom( PROPERTY_HINT_NONE, "suffix:px/s" ) var acceleration: float = 8
@export var ground_slam_time : float = 0.1

@export var jump_audio : AudioStream

func enter():
	player.anim_player.play( "Jump" )
	player.play_oneshot_sfx(jump_audio)
	player.velocity.y += -jump_velocity
	player.sprite.rotation = 0
	pass

func exit():
	pass

func handle_input(_event: InputEvent) -> PlayerState:
	if _event.is_action_pressed("Attack"):
		return attack
	if _event.is_action_pressed("Dash"):
		if not player.has_dash:
			return null
		player.has_dash = false
		return dash
	if _event.is_action_pressed("GroundSlam"):
		return ground_slam
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
	
	if player.velocity.y >= 0:
		return fall
	return null
