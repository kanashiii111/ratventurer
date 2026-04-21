class_name Player extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

@onready var player_state_machine = $StateMachine
@onready var sprite = $Sprite
@onready var anim_player = $AnimationPlayer
@onready var audio_player = $AudioStreamPlayer2D

func _ready() -> void:
	player_state_machine.init( self )
	pass

func _physics_process( _delta: float ) -> void:
	$Label.text = "curr: " + str(player_state_machine.curr_state).split(":")[0]
	$Label2.text = str(player_state_machine.player.velocity.x)
	$Label3.text = str(player_state_machine.player.velocity.y)
	$Label4.text = "prev: " + str(player_state_machine.prev_state).split(":")[0]
	gravity(_delta)
	move_and_slide()

func gravity( _delta: float ):
	if not is_on_floor():
		velocity.y += get_gravity().y * _delta

func update_velocity( _velocity: float, _acceleration: float) -> void:
	velocity.x = move_toward(velocity.x, _velocity, _acceleration) 
	
func update_animation_direction():
	if self.velocity.x < 0 : sprite.flip_h = true
	if self.velocity.x > 0 : sprite.flip_h = false

func update_animation_rotation():
	if is_on_floor():
		var normal = get_floor_normal()
		var angle = normal.angle() + PI / 2
		sprite.rotation = angle * 0.5
	else:
		sprite.rotation = 0

func play_audio( audio : AudioStream ):
	if audio == null:
		return
	audio_player.stream = audio
	audio_player.play()
