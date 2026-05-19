class_name PlayerSlideState extends PlayerState

@export var slide_time : float = 0.125

var slide_timer : float

func enter():
	player.anim_player.play( "Slide" )
	player.velocity.x += direction.x * 50
	slide_timer = slide_time
	player.player_collider.shape.size.y = player.SLIDE_SHAPE_SIZE_Y
	player.player_collider.position.y = player.SLIDE_POSITION_Y
	
func exit():
	player.sprite.rotation = 0
	player.player_collider.shape.size.y = player.AFTER_SLIDE_SHAPE_SIZE_Y
	player.player_collider.position.y = player.AFTER_SLIDE_POSITION_Y
	pass

func handle_input( _event: InputEvent) -> PlayerState: 
	if _event.is_action_pressed( "Jump" ):
		player.velocity.x *= 1.1
		return jump
	return null

func process( _delta: float ) -> PlayerState:
	if slide_timer <= 0:
		return run
	if abs(player.velocity.x) < 0.1:
		if player.is_ceiling_above():
			return crouch_idle
		else:
			return idle
	if not player.is_on_floor():
		return fall
	return null
	
func physics_process(_delta: float) -> PlayerState:
	player.update_animation_direction()
	player.update_animation_rotation()
	
	var input_dir = Input.get_axis("MoveLeft", "MoveRight")
	
	player.gravity(_delta)
	
	if player.is_on_floor():
		var normal = player.get_floor_normal()
		var gravity_dir = player.get_gravity().normalized()
		var downhill = gravity_dir.slide(normal).normalized()
		var moving_up = player.velocity.dot(downhill) < 0
		var moving_down = player.velocity.dot(downhill) > 0
		
		var same_dir = (player.velocity.x > 0 and input_dir > 0) or (player.velocity.x < 0 and input_dir < 0)
		
		if same_dir and moving_up:
			slide_timer -= _delta
			
		if moving_down: #player.velocity.x = move_toward(player.velocity.x, player.velocity.x * 1.5, 100 * _delta)
			var slope_acceleration = 200.0 
			player.velocity.x = move_toward(player.velocity.x, direction.x * 600, slope_acceleration * _delta)
		
		if input_dir == 0 and moving_up:
			player.velocity.x = move_toward(player.velocity.x, 0, 500 * _delta)
		
		if player.velocity.x > 0 and input_dir < 0:
			player.velocity.x = move_toward(player.velocity.x, 0, 2500 * _delta)

		if player.velocity.x < 0 and input_dir > 0:
			player.velocity.x = move_toward(player.velocity.x, 0, 2500 * _delta)
	
	return null
