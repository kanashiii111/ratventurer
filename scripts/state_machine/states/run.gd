class_name PlayerRunState extends PlayerState

@export_custom( PROPERTY_HINT_NONE, "suffix:px/s" ) var speed: float = 150
@export_custom( PROPERTY_HINT_NONE, "suffix:px/s" ) var acceleration: float = 8

var curr_direction : float = 0

func init():
	pass

func enter():
	print("Entered state : RUN")
	pass

func exit():
	pass

func handle_input(_event: InputEvent) -> PlayerState: 
	return null

func process(_delta: float) -> PlayerState:
	
	return null

func physics_process(_delta: float) -> PlayerState:
	if not player.is_on_floor():
		return fall
	if direction.x == 0: return idle
	
	player.update_velocity( direction.x * speed, acceleration )
	return null
