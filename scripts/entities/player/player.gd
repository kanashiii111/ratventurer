class_name Player extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

@onready var player_state_machine = $StateMachine
@onready var sprite = $Sprite
@onready var anim_player = $AnimationPlayer

func _ready() -> void:
	player_state_machine.init( self )
	pass

func _physics_process( _delta: float ) -> void:
	$Label.text = str(player_state_machine.curr_state).split(":")[0]
	gravity(_delta)
	move_and_slide()

func gravity( _delta: float ):
	if not is_on_floor():
		velocity += get_gravity() * _delta

func update_velocity( _velocity: float, _acceleration: float) -> void:
	velocity.x = move_toward(velocity.x, _velocity, _acceleration) 
