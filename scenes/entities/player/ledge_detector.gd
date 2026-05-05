extends RayCast2D

var ledge_detector: RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ledge_detector = $"."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout():
	var line = Line2D.new()
	add_child(line)
	line.global_position = ledge_detector.global_position
	line.add_point(Vector2.ZERO)
	line.add_point(ledge_detector.target_position - line.global_position)
	line.width = 3
	
	await get_tree().create_timer(1.0).timeout
	line.queue_free()
