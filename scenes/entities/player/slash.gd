extends Node

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	anim_player.play("Slash")
	anim_player.animation_finished.connect(func(_name): queue_free())

func _process(_delta: float) -> void:
	pass
