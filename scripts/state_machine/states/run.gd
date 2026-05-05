class_name PlayerRunState extends PlayerState

@export_custom( PROPERTY_HINT_NONE, "suffix:px/s" ) var speed: float = 200
@export_custom( PROPERTY_HINT_NONE, "suffix:px/s" ) var acceleration: float = 20
@export var run_audio : AudioStream

func init():
	pass

func enter():
	player.anim_player.play( "Run" )
	pass

func exit():
	pass

func handle_input( _event: InputEvent ) -> PlayerState: 
	if _event.is_action_pressed("Dash"):
		return dash
	if _event.is_action_pressed( "Jump" ):
		return jump
	if _event.is_action_pressed( "Slide" ) and abs(player.velocity.x) > 150:
		return slide
	return null

func process( _delta: float ) -> PlayerState:
	return null

func physics_process( _delta: float ) -> PlayerState:
	player.update_animation_direction()
	player.update_animation_rotation()
	
	if not player.is_on_floor():
		return fall
		
	if direction.x == 0: return idle
	
	var target_vel = direction.x * speed
	# Если мы бежим быстрее 'speed' (например, после слайда), 
	# плавно замедляемся или держим скорость, пока зажата кнопка
	if sign(direction.x) == sign(player.velocity.x) and abs(player.velocity.x) > speed:
		# Здесь можно либо target_vel = player.velocity.x (вечный полет),
		# либо использовать меньшее ускорение для постепенного торможения до speed
		target_vel = player.velocity.x
	
	player.update_velocity(target_vel, acceleration)
	#player.update_velocity( direction.x * speed, acceleration )
	return null
