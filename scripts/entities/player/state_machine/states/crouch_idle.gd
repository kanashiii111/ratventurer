class_name PlayerCrouchIdleState extends PlayerState

func _ready() -> void:
	pass 

func _process(_delta: float) -> void:
	pass

func init():
	pass

func enter():
	player.player_collider.shape.size.y = player.SLIDE_SHAPE_SIZE_Y
	player.player_collider.position.y = player.SLIDE_POSITION_Y
	player.anim_player.play("Crouch")
	
	if state_machine.prev_state.name == "Slide" and not Input.is_action_pressed("Slide"):
		player.want_to_uncrouch = true
	else:
		player.want_to_uncrouch = false

func exit():
	player.sprite.rotation = 0
	player.player_collider.shape.size.y = player.AFTER_SLIDE_SHAPE_SIZE_Y
	player.player_collider.position.y = player.AFTER_SLIDE_POSITION_Y

func handle_input(_event: InputEvent) -> PlayerState:
	if direction.x != 0: return crouch_walk
	if _event.is_action_released("Slide"):
		player.want_to_uncrouch = true
	
	if _event.is_action_pressed("Slide"):
		player.want_to_uncrouch = false
	
	return null

func process(_delta: float) -> PlayerState:
	return null

func physics_process(_delta: float) -> PlayerState:
	player.update_animation_direction()
	player.update_animation_rotation()
	
	if direction.x != 0:
		return crouch_walk
	
	if player.want_to_uncrouch and not player.is_ceiling_above():
		player.want_to_uncrouch = false
		return idle
	
	player.update_velocity( 0, 20 )
	
	if not player.is_on_floor():
		return fall
	
	return null 
