extends Area2D

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@export var collect_audio: AudioStream

func _ready() -> void:
	add_to_group("cheese")
	body_entered.connect(_on_body_entered)
	anim_player.play("idle")
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.collect_cheese()
		if collect_audio:
			body.get_node("AudioStreamPlayer2D2").stream = collect_audio
			body.get_node("AudioStreamPlayer2D2").play()
		queue_free()
