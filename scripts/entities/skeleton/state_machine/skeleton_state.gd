class_name SkeletonState extends Node

var skeleton: Skeleton
var state_machine: SkeletonStateMachine

@onready var idle = %Idle
@onready var walk = %Walk
@onready var chase = %Chase
@onready var attack = %Attack
@onready var fall = %Fall
@onready var death = %Death

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

func handle_input(_event: InputEvent) -> SkeletonState: 
	return null

func process(_delta: float) -> SkeletonState:
	return null

func physics_process(_delta: float) -> SkeletonState:
	return null 
