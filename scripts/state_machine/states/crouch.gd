class_name PlayerCrouchState extends PlayerState

var need_no_uncrouch: bool = false

func _ready() -> void:
	pass 

func _process(_delta: float) -> void:
	pass

func init():
	pass

func enter():
	player.player_collider.shape.size.y = player.SLIDE_SHAPE_SIZE_Y
	player.player_collider.position.y = player.SLIDE_POSITION_Y

func exit():
	player.sprite.rotation = 0
	player.player_collider.shape.size.y = player.AFTER_SLIDE_SHAPE_SIZE_Y
	player.player_collider.position.y = player.AFTER_SLIDE_POSITION_Y

func handle_input(_event: InputEvent) -> PlayerState: 
	#if not _event.is_action_pressed("Slide"):
		#return idle
	if not player.is_ceiling_above() and need_no_uncrouch:
		if _event.is_action_pressed("Slide"):
			return null
		else: 
			return idle
	if _event.is_action_released("Slide"):
		if player.is_ceiling_above():
			need_no_uncrouch = true
			return null
		else:
			return idle
	return null

func process(_delta: float) -> PlayerState:
	return null

func physics_process(_delta: float) -> PlayerState:
	player.update_animation_direction()
	player.update_animation_rotation()
	
	var target_speed = direction.x * 100
	player.update_velocity( target_speed, 20 )
	
	if not player.is_on_floor():
		return fall
	
	return null 
