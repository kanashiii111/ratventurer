class_name PlayerFallState extends PlayerState

@export_custom( PROPERTY_HINT_NONE, "suffix:px/s" ) var speed: float = 200
@export_custom( PROPERTY_HINT_NONE, "suffix:px/s" ) var acceleration: float = 20
@export var coyote_time : float = 0.125

@export var fall_audio : AudioStream

var coyote_timer : float

func init():
	pass

func enter():
	player.rotation = 0
	player.anim_player.play( "Fall" )
	player.play_audio( fall_audio )
	coyote_timer = coyote_time 
	if state_machine.prev_state == jump:
		coyote_timer = 0
	pass

func exit():
	player.audio_player.stop()
	pass

func handle_input( _event: InputEvent ) -> PlayerState:
	if _event.is_action_pressed("Dash"):
		return dash
	if player.is_on_wall():
		if player.is_at_ledge() and _event.is_action_pressed("Jump"):
			return vault
		#if _event.is_action_pressed("Jump"):
			#return latch
	
	if coyote_timer > 0:
		if _event.is_action_pressed( "Jump" ):
			return jump 
	return null

func process(_delta: float) -> PlayerState:
	return null

func physics_process(_delta: float) -> PlayerState:
	#player.update_animation_direction()
	#coyote_timer -= _delta
	#
	#player.update_velocity( direction.x * speed, acceleration )
	
	player.update_animation_direction()
	coyote_timer -= _delta
	
	var target_vel = direction.x * speed
	# Проверка на сохранение высокой скорости в воздухе
	if direction.x != 0 and sign(direction.x) == sign(player.velocity.x) and abs(player.velocity.x) > speed:
		target_vel = player.velocity.x
		
	player.update_velocity(target_vel, acceleration)
	
	if player.is_on_floor():
		return idle
	return null
