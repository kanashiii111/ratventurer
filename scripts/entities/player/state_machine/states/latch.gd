class_name PlayerLatchState extends PlayerState

func init():
	pass

func enter():
	pass

func exit():
	pass

func handle_input( _event: InputEvent) -> PlayerState:
	if _event.is_action_pressed("Jump"):
		player.velocity.y = -100
		return jump
	return latch

func process( _delta: float ) -> PlayerState:
	return latch

func physics_process(_delta: float) -> PlayerState:
	player.update_animation_direction()
	player.update_animation_rotation()
	
	return latch
