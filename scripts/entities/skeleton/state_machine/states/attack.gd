class_name SkeletonAttackState extends SkeletonState

func _ready() -> void:
	pass

func enter() -> void:
	skeleton.animation_player.play("Attack")
	#for body in skeleton.player_attack_area.get_overlapping_bodies():
		#if body is Player:
			##body.queue_free()
			#get_tree().call_deferred("reload_current_scene")

func process(_delta: float) -> SkeletonState:
	return null

func physics_process(_delta: float) -> SkeletonState:
	skeleton.update_animation_direction()
	if not skeleton.animation_player.is_playing():
		for body in skeleton.player_attack_area.get_overlapping_bodies():
			if body is Player:
				get_tree().call_deferred("reload_current_scene")
		return chase
	return null
