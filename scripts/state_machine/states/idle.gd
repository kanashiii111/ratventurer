class_name PlayerIdleState extends PlayerState

@export var deceleration : float = 20

func init():
	pass

func enter():
	player.anim_player.play( "Idle" )
	player.has_dash = true
	pass

func exit():
	pass

func handle_input( _event: InputEvent) -> PlayerState: 
	if _event.is_action_pressed("Slide"):
		return crouch
	if _event.is_action_pressed( "Jump" ):
		return jump
	return null

func process( _delta: float ) -> PlayerState:
	if direction.x != 0: return run
	return null

func physics_process( _delta: float ) -> PlayerState:
	player.update_animation_direction()
	player.update_animation_rotation()
	player.update_velocity( 0, deceleration )
	
	if not player.is_on_floor():
		return fall
		
	return null 
