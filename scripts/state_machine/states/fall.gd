class_name PlayerFallState extends PlayerState

func init():
	pass

func enter():
	print("Entered state : FALL")
	player.anim_player.play( "Fall" )
	pass

func exit():
	pass

func handle_input(_event: InputEvent) -> PlayerState: 
	return null

func process(_delta: float) -> PlayerState:
	return null

func physics_process(_delta: float) -> PlayerState:
	if player.is_on_floor():
		return idle
	return null
