extends Node2D

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	anim_player.play("Slam")
	anim_player.animation_finished.connect(func(_name): queue_free())
