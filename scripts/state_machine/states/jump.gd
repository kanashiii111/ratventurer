class_name PlayerJumpState extends PlayerState

func init():
	pass

func enter():
	print("Entered state : JUMP")
	player.anim_player.play( "Jump" )
	pass

func exit():
	pass

func handle_input(_event: InputEvent) -> PlayerState: 
	return null

func process(_delta: float) -> PlayerState:
	return null

func physics_process(_delta: float) -> PlayerState:
	return null
