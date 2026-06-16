extends Area2D

func _ready() -> void:
	add_to_group("cheese")
	body_entered.connect(_on_body_entered)
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(-6, -6, 12, 12), Color.YELLOW)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.collect_cheese()
		queue_free()
