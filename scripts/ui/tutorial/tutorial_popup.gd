extends Control

@onready var label: Label = $Label

func show_text(text: String, duration: float = 0.0) -> void:
	label.text = tr(text)
	show()
	if duration > 0.0:
		await get_tree().create_timer(duration).timeout
		hide()

func hide_text() -> void:
	hide()
