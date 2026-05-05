class_name PlayerVaultState extends PlayerState

var jump_velocity: int = 250

func init():
	pass

func enter():
	#player.anim_player.play( "Slide" )
	player.velocity.y += -jump_velocity * 0.8
	player.velocity.x = direction.x * 200 * 1.1
	
func exit():
	player.sprite.rotation = 0
	pass

func handle_input( _event: InputEvent) -> PlayerState: 
	return null

func process( _delta: float ) -> PlayerState:
	if abs(player.velocity.x) < 0.1:
		return idle
	if not player.is_on_floor():
		return fall
	return vault
	
func physics_process(_delta: float) -> PlayerState:
	player.update_animation_direction()
	player.update_animation_rotation()
	
	
	return null
