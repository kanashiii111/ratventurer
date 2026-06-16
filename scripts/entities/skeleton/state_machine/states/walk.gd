class_name SkeletonWalkState extends SkeletonState

var skeleton_speed : float = 65
@export_range(-1, 1) var direction: int = 1

@onready var right_wall_ray: RayCast2D = $"../../RightWallRay"
@onready var left_wall_ray: RayCast2D = $"../../LeftWallRay"
@onready var right_ray: RayCast2D = $"../../RightRay"
@onready var left_ray: RayCast2D = $"../../LeftRay"

func _ready() -> void:
	if direction == 0:
		direction = 1

func enter() -> void:
	skeleton.animation_player.play( "Walk" )

func process(_delta: float) -> SkeletonState:
	return null

func physics_process(_delta: float) -> SkeletonState:
	skeleton.update_animation_direction()
	if direction == 1 and (!right_ray.is_colliding() or right_wall_ray.is_colliding()):
		direction = -1
	if direction == -1 and (!left_ray.is_colliding() or left_wall_ray.is_colliding()):
		direction = 1
	skeleton.velocity.x = lerp(skeleton.velocity.x, direction * skeleton_speed, 10.0 * _delta)
	return null
