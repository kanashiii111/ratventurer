class_name SkeletonChaseState extends SkeletonState

var skeleton_speed : float = 200
var acceleration : float = 20

func _ready() -> void:
	pass

func process(_delta: float) -> SkeletonState:
	return null

func physics_process(_delta: float) -> SkeletonState:
	skeleton.update_animation_direction()
	var direction = (skeleton.player.global_position - skeleton.global_position).normalized()
	skeleton.velocity = lerp(skeleton.velocity, direction * skeleton_speed, _delta)
	return null
