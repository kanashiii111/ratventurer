class_name PlayerAttackState extends PlayerState

const SLASH_EFFECT = preload("res://scenes/entities/player/effects/slash_effect.tscn")
var attack_finished: bool = false
var speed: int = 200
var acceleration: int = 20

@export var attack_audio : AudioStream

func _ready() -> void:
	pass 

func _process(_delta: float) -> void:
	pass

func init():
	pass

func enter():
	player.anim_player.play("Attack")
	player.play_oneshot_sfx(attack_audio)
	spawn_slash_effect()

func exit():
	pass

func handle_input(_event: InputEvent) -> PlayerState:
	if _event.is_action_pressed("Attack"):
		return self
	if _event.is_action_pressed("Dash"):
		if not player.is_on_floor():
			if not player.has_dash:
				return null
			player.has_dash = false
		return dash
	if _event.is_action_pressed("Jump") and player.is_on_floor():
		return jump
	return null
	

func process(_delta: float) -> PlayerState:
	if not player.anim_player.is_playing() or player.anim_player.current_animation != "Attack":
		if Input.is_action_pressed("Attack"):
			return self
		if direction.x != 0: 
			return run
		return idle
		
	return null

func physics_process(_delta: float) -> PlayerState:
	player.update_animation_direction()
	player.update_animation_rotation()
	
	var target_vel = direction.x * speed
	if sign(direction.x) == sign(player.velocity.x) and abs(player.velocity.x) > speed:
		target_vel = speed
		player.update_velocity(target_vel, 5)
		return null
	
	player.update_velocity(target_vel, acceleration)
	
	if not player.is_on_floor():
		return fall
	
	return null

func spawn_slash_effect():
	var slash = SLASH_EFFECT.instantiate()
	
	var facing_dir = -1 if player.sprite.flip_h else 1
	slash.global_position = player.global_position + Vector2(20 * facing_dir, 0)
	
	slash.position = Vector2(player.attack_marker.position.x * facing_dir, player.attack_marker.position.y)
	slash.scale.x = facing_dir
	player.add_child(slash)
