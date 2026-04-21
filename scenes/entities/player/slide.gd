class_name PlayerSlideState extends PlayerState

@export var slide_time : float = 0.125

var slide_timer : float

func init():
	pass

func enter():
	player.anim_player.play( "Slide" )
	if (player.velocity.x > 0):
		player.velocity.x += 50
	elif (player.velocity.x < 0):
		player.velocity.x -= 50
	slide_timer = slide_time
	
func exit():
	player.sprite.rotation = 0
	pass

func handle_input( _event: InputEvent) -> PlayerState: 
	if _event.is_action_pressed( "Jump" ):
		return jump
	return null

func process( _delta: float ) -> PlayerState:
	if slide_timer <= 0:
		return run
	if abs(player.velocity.x) < 0.1:
		return idle
	if not player.is_on_floor():
		return fall
	return slide
	
func physics_process(_delta: float) -> PlayerState:
	player.update_animation_direction()
	player.update_animation_rotation()
	
	var input_dir = Input.get_axis("MoveLeft", "MoveRight")
	
	if player.is_on_floor():
		var normal = player.get_floor_normal()
		var gravity_dir = player.get_gravity().normalized()
		var downhill = gravity_dir.slide(normal).normalized()
		var moving_up = player.velocity.dot(downhill) < 0
		
		var same_dir = (player.velocity.x > 0 and input_dir > 0) or (player.velocity.x < 0 and input_dir < 0)
		
		if same_dir and moving_up:
			slide_timer -= _delta
		
		if input_dir == 0 and moving_up:
			player.velocity.x = move_toward(player.velocity.x, 0, 500 * _delta)
		
		if player.velocity.x > 0 and input_dir < 0:
			player.velocity.x = move_toward(player.velocity.x, 0, 2500 * _delta)

		if player.velocity.x < 0 and input_dir > 0:
			player.velocity.x = move_toward(player.velocity.x, 0, 2500 * _delta)
			
	return null
