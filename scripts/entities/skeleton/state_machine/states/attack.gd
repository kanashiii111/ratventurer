class_name SkeletonAttackState extends SkeletonState

func _ready() -> void:
	pass

func enter() -> void:
	for body in skeleton.player_attack_area.get_overlapping_bodies():
		if body is Player:
			#body.queue_free()
			get_tree().call_deferred("reload_current_scene")

func process(_delta: float) -> SkeletonState:
	return null

func physics_process(_delta: float) -> SkeletonState:
	skeleton.update_animation_direction()
	return null
