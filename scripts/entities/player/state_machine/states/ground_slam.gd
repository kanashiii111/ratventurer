class_name PlayerGroundSlamState extends PlayerState

@export var ground_slam_speed : float = 1000

var prev_collision_layer: int

func init():
	pass

func enter():
	#player.anim_player.play("GroundSlam")
	prev_collision_layer = player.collision_layer
	player.collision_layer = 1
	player.velocity.y = ground_slam_speed
	player.rotation = 0

func exit():
	player.collision_layer = prev_collision_layer
	for body in player.ground_slam_hitbox.get_overlapping_bodies():
		if body is Skeleton:
			body.queue_free()

func handle_input( _event: InputEvent ) -> PlayerState:
	return null

func process(_delta: float) -> PlayerState:
	return null

func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = 0
	
	if player.is_on_floor():
		return idle
	return null
