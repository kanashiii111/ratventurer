class_name Player extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

@onready var player_state_machine : StateMachine = $StateMachine
@onready var sprite = $Sprite
@onready var anim_player = $AnimationPlayer
@onready var audio_player = $AudioStreamPlayer2D

func _ready() -> void:
	player_state_machine.init( self )
	pass

func _physics_process( _delta: float ) -> void:
	$Label.text = "curr: " + player_state_machine.curr_state.name
	$Label2.text = str(player_state_machine.player.velocity.x)
	$Label3.text = str(player_state_machine.player.velocity.y)
	$Label4.text = "prev: " + player_state_machine.prev_state.name
	gravity(_delta)
	move_and_slide()

func gravity( _delta: float ):
	if player_state_machine.curr_state.name == "Latch":
		velocity = Vector2.ZERO
		return
	
	if not is_on_floor():
		velocity.y += get_gravity().y * _delta

func update_velocity( _velocity: float, _acceleration: float) -> void:
	velocity.x = move_toward(velocity.x, _velocity, _acceleration)
	
func update_animation_direction():
	if self.velocity.x < 0 or sign(Input.get_axis("MoveLeft", "MoveRight")) == -1:
		sprite.flip_h = true
	if self.velocity.x > 0 or sign(Input.get_axis("MoveLeft", "MoveRight")) == 1:
		sprite.flip_h = false

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
