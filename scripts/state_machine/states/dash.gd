class_name PlayerDashState extends PlayerState

@export var dash_speed: float = 300.0
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 0.5

var dash_timer: float = 0.0
var cooldown_timer: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO

func init():
	pass

func enter():
	player.anim_player.play("Dash") # Если есть анимация
	# Фиксируем направление в момент нажатия
	dash_direction = direction if direction.x != 0 else Vector2(player.sprite.scale.x, 0)
	player.velocity.x = dash_direction.x * dash_speed
	player.velocity.y = 0 # Замораживаем вертикальную скорость
	dash_timer = dash_duration
	
func exit():
	player.sprite.rotation = 0
	pass

func handle_input( _event: InputEvent) -> PlayerState: 
	# "Dash-Jump": если нажать прыжок во время деша, получаем огромный импульс
	if _event.is_action_pressed("Jump"):
		player.velocity.x *= 1.2 # Дополнительный буст к инерции
		return jump
	return null

func process( _delta: float ) -> PlayerState:
	if abs(player.velocity.x) < 0.1:
		return idle
	#if not player.is_on_floor():
		#return fall
	return dash
	
func physics_process(_delta: float) -> PlayerState:
	#player.update_animation_direction()
	#player.update_animation_rotation()
	
	dash_timer -= _delta
	
	# Сохраняем скорость деша стабильной во время действия
	player.velocity.x = dash_direction.x * dash_speed
	player.velocity.y = 0 

	if dash_timer <= 0:
		if player.is_on_floor():
			player.velocity.x = direction.x * 200
			return run
		return fall
	
	return null
