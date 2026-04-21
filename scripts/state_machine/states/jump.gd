class_name PlayerJumpState extends PlayerState

@export var jump_velocity : float = 350.0
@export_custom( PROPERTY_HINT_NONE, "suffix:px/s" ) var speed: float = 150
@export_custom( PROPERTY_HINT_NONE, "suffix:px/s" ) var acceleration: float = 8

@export var jump_audio : AudioStream

func enter():
	player.anim_player.play( "Jump" )
	player.play_audio(jump_audio)
	player.global_position.y -= 1
	player.velocity.y = -jump_velocity
	player.sprite.rotation = 0
	pass

func exit():
	pass

func handle_input(_event: InputEvent) -> PlayerState:
	if _event.is_action_released("Jump"):
		player.velocity.y *= 0.5
		return fall 
	return null

func process(_delta: float) -> PlayerState:
	return null

func physics_process(_delta: float) -> PlayerState:
	player.update_animation_direction()
	player.update_velocity( direction.x * speed, acceleration )
	
	if player.is_on_floor():
		return idle
	elif player.velocity.y >= 0:
		return fall
	return null
