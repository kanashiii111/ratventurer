class_name SkeletonIdleState extends SkeletonState

var deceleration: int = 20

func _ready() -> void:
	pass

func process(_delta: float) -> SkeletonState:
	return null

func physics_process(_delta: float) -> SkeletonState:
	skeleton.update_animation_direction()
	skeleton.update_velocity(0, deceleration)
	if not skeleton.is_on_floor():
		return fall
	return null
