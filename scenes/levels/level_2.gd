extends Node2D

var canvas: CanvasModulate

func _ready() -> void:
	canvas = get_node_or_null("CanvasModulate")
	canvas.color = Color(0.475, 0.475, 0.475, 1.0)

func _process(_delta: float) -> void:
	pass


func _on_light_area_body_entered(_body: Node2D) -> void:
	canvas.color = Color(0.796, 0.796, 0.796, 1.0)


func _on_light_area_body_exited(_body: Node2D) -> void:
	canvas.color = Color(0.475, 0.475, 0.475, 1.0)
