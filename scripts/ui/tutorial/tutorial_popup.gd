extends Node2D

@onready var label: Label = $Label

var popup_tween: Tween

func show_text(text: String, duration: float = 0.0) -> void:
	if popup_tween and popup_tween.is_running():
		popup_tween.kill()

	label.text = tr(text)
	modulate = Color(1, 1, 1, 0)
	show()

	popup_tween = create_tween()
	popup_tween.tween_property(self, "modulate", Color.WHITE, 0.3)

	if duration > 0.0:
		await get_tree().create_timer(duration).timeout
		hide_text()

func hide_text() -> void:
	if popup_tween and popup_tween.is_running():
		popup_tween.kill()

	popup_tween = create_tween()
	popup_tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.3)
	await popup_tween.finished
	hide()
