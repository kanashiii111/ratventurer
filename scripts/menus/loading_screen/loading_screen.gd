extends CanvasLayer

var _label: Label

func _ready() -> void:
	layer = 128

	var bg := ColorRect.new()
	bg.name = "Background"
	bg.color = Color(0.0, 0.0, 0.0, 1.0)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(bg)

	_label = Label.new()
	_label.name = "Label"
	_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label.add_theme_font_size_override("font_size", 36)
	_label.add_theme_color_override("font_color", Color(1, 1, 1))
	_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
	_label.add_theme_constant_override("outline_size", 8)
	bg.add_child(_label)

	visible = false

func hide_loading() -> void:
	visible = false

func switch_scene(path: String) -> void:
	_label.text = tr("loading")
	visible = true
	await RenderingServer.frame_post_draw
	get_tree().change_scene_to_file(path)
	visible = false

func reload_current_scene() -> void:
	switch_scene(get_tree().current_scene.scene_file_path)
