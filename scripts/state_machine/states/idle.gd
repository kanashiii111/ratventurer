class_name PlayerIdleState extends PlayerState

@export var deceleration : float = 4

func init():
	pass

func enter():
	print("Entered state : IDLE")
	player.anim_player.play( "Idle" )
	pass

func exit():
	pass

func handle_input(_event: InputEvent) -> PlayerState: 
	return null

func process(_delta: float) -> PlayerState:
	if direction.x != 0: return run
	return null

func physics_process(_delta: float) -> PlayerState:
	player.update_velocity( 0, deceleration )
	if not player.is_on_floor():
		return fall
	return null 
