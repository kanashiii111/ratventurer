extends Node

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox: Area2D = $Hitbox

func _ready() -> void:
	anim_player.play("Slash")
	anim_player.animation_finished.connect(func(_name): queue_free())
	hitbox.body_entered.connect(_on_hitbox_body_entered)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Skeleton:
		body.queue_free()

func _process(_delta: float) -> void:
	pass
