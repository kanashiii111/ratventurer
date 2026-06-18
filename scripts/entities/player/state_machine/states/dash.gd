class_name PlayerDashState extends PlayerState

@export var dash_speed: float = 300.0
@export var dash_duration: float = 0.3

var dash_timer: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO

@export var dash_audio : AudioStream

func init():
	pass

func enter():
	player.anim_player.play("Dash")
	player.play_audio(dash_audio)
	
	dash_direction = direction if direction.x != 0 else Vector2(-1 if player.sprite.flip_h else 1, 0)
	if abs(player.velocity.x) > dash_speed:
		player.velocity.x += dash_direction.x * player.velocity.x / 10
	else:
		player.velocity.x = dash_direction.x * dash_speed
	player.velocity.y = 0
	dash_timer = dash_duration
	
func exit():
	player.sprite.rotation = 0
	pass

func handle_input( _event: InputEvent) -> PlayerState: 
	if _event.is_action_pressed("GroundSlam"):
		return ground_slam
	if _event.is_action_pressed("Attack"):
		return attack
	if _event.is_action_pressed("Jump"):
		player.velocity.x *= 1.2
		return jump
	return null

func process( _delta: float ) -> PlayerState:
	if abs(player.velocity.x) < 0.1:
		return idle
	return null
	
func physics_process(_delta: float) -> PlayerState:
	dash_timer -= _delta
	player.velocity.y = 0

	if dash_timer <= 0:
		if player.is_on_floor():
			return run
		return fall
	
	return null
