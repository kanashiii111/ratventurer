class_name SkeletonFallState extends SkeletonState

func _ready() -> void:
	pass

func process(_delta: float) -> SkeletonState:
	return null

func physics_process(_delta: float) -> SkeletonState:
	skeleton.update_animation_direction()
	if skeleton.is_on_floor():
		return idle
	return null
