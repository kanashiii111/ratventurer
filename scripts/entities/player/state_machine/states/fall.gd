class_name PlayerFallState extends PlayerState

@export_custom( PROPERTY_HINT_NONE, "suffix:px/s" ) var speed: float = 200
@export_custom( PROPERTY_HINT_NONE, "suffix:px/s" ) var acceleration: float = 20
@export var coyote_time : float = 0.125
@export var ground_slam_time : float = 0.1

@export var fall_audio : AudioStream

var coyote_timer : float

func init():
	pass

func enter():
	player.rotation = 0
	player.anim_player.play( "Fall" )
	player.play_looping_sfx( fall_audio )
	coyote_timer = coyote_time 
	if state_machine.prev_state == jump or state_machine.prev_state == wall_jump:
		coyote_timer = 0
	pass

func exit():
	player.sfx_looping_player.stop()
	pass

func handle_input( _event: InputEvent ) -> PlayerState:
	if _event.is_action_pressed("Attack"):
		return attack
	if _event.is_action_pressed("Dash"):
		if not player.has_dash:
			return null
		player.has_dash = false
		return dash
	if _event.is_action_pressed("GroundSlam"):
		return ground_slam
	if player.wall_detector.is_colliding() and _event.is_action_pressed("Jump"):
		return wall_jump
	if coyote_timer > 0 and not player.player_state_machine.prev_state.name == "Attack":
		if _event.is_action_pressed( "Jump" ):
			return jump 
	return null

func process(_delta: float) -> PlayerState:
	return null

func physics_process(_delta: float) -> PlayerState:
	player.update_animation_direction()
	coyote_timer -= _delta
	
	var target_vel = direction.x * speed
	if direction.x != 0 and sign(direction.x) == sign(player.velocity.x) and abs(player.velocity.x) > speed:
		target_vel = player.velocity.x
		
	player.update_velocity(target_vel, acceleration)
	
	if player.is_on_floor():
		return idle
	return null
