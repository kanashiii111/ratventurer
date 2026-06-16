class_name SkeletonDeathState extends SkeletonState

func enter():
	skeleton.animation_player.play("Death")
	skeleton.velocity = Vector2.ZERO
	skeleton.animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name: String):
	if anim_name == "Death":
		skeleton.queue_free()

func exit():
	if skeleton.animation_player.animation_finished.is_connected(_on_animation_finished):
		skeleton.animation_player.animation_finished.disconnect(_on_animation_finished)

func physics_process(_delta):
	skeleton.velocity = Vector2.ZERO
	return null
