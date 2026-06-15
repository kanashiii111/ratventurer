class_name PlayerGroundSlamState extends PlayerState

@export var ground_slam_speed : float = 2000

func init():
	pass

func enter():
	#player.anim_player.play("GroundSlam")
	player.velocity.y = ground_slam_speed
	player.rotation = 0

func exit():
	pass

func handle_input( _event: InputEvent ) -> PlayerState:
	return null

func process(_delta: float) -> PlayerState:
	return null

func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = 0
	if player.is_on_floor():
		return idle
	return null
