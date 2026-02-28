class_name PlayerFallState extends PlayerState

@export_custom( PROPERTY_HINT_NONE, "suffix:px/s" ) var speed: float = 150
@export_custom( PROPERTY_HINT_NONE, "suffix:px/s" ) var acceleration: float = 8
@export var coyote_time : float = 0.125

var coyote_timer : float

func init():
	pass

func enter():
	player.anim_player.play( "Fall" )
	coyote_timer = coyote_time
	if state_machine.prev_state == jump:
		coyote_timer = 0
	pass

func exit():
	pass

func handle_input(_event: InputEvent) -> PlayerState:
	if coyote_timer > 0:
		if _event.is_action_pressed("Jump"):
			return jump 
	return null

func process(_delta: float) -> PlayerState:
	return null

func physics_process(_delta: float) -> PlayerState:
	player.update_animation_direction()
	coyote_timer -= _delta
	player.update_velocity( direction.x * speed, acceleration )
	if player.is_on_floor():
		return idle
	return null
