class_name PlayerVaultState extends PlayerState

var jump_velocity: int = 250
var min_vault_speed: int = 200

func init():
	pass

func enter():
	player.velocity.y += -jump_velocity
	player.velocity.x = player.velocity.x * 1.1
	
func exit():
	player.sprite.rotation = 0
	pass

func handle_input( _event: InputEvent) -> PlayerState: 
	if _event.is_action_pressed("Dash"):
		return dash
	return null

func process( _delta: float ) -> PlayerState:
	#if abs(player.velocity.x) < 0.1:
		#return idle
	
	if not player.is_on_floor():
		return fall
	return null
	
func physics_process(_delta: float) -> PlayerState:
	player.update_animation_direction()
	player.update_animation_rotation()
	
	player.velocity.x = direction.x * min_vault_speed
	
	return null
