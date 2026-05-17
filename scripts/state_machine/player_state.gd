class_name PlayerState extends Node

static var player: Player
static var state_machine: StateMachine
static var direction: Vector2

@onready var idle: PlayerIdleState = %Idle
@onready var run: PlayerRunState = %Run
@onready var jump: PlayerJumpState = %Jump
@onready var fall: PlayerFallState = %Fall
@onready var slide: PlayerSlideState = %Slide
@onready var latch: PlayerLatchState = %Latch
@onready var vault: PlayerVaultState = %Vault
@onready var dash: PlayerDashState = %Dash
@onready var crouch: PlayerCrouchState = %Crouch
@onready var wall_jump: PlayerWallJumpState = %WallJump

func _ready() -> void:
	pass 

func _process(_delta: float) -> void:
	pass

func init():
	pass

func enter():
	pass

func exit():
	pass

func handle_input(_event: InputEvent) -> PlayerState: 
	return null

func process(_delta: float) -> PlayerState:
	return null

func physics_process(_delta: float) -> PlayerState:
	return null 
