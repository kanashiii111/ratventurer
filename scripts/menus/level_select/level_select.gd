extends Control

@onready var container: HBoxContainer = $HBoxContainer
@onready var back_button: Button = $BackButton

const LEVEL_ORDER: Array[String] = [
	"level_tutorial",
	"level_1",
	"level_2",
	"level_3",
]

func _ready() -> void:
	Engine.time_scale = 1.0
	back_button.pressed.connect(_on_back)

	for level_id in LEVEL_ORDER:
		var data: Dictionary = GameManager.LEVEL_DATA.get(level_id, {})
		var card := _create_card(level_id, data)
		container.add_child(card)

func _create_card(level_id: String, _data: Dictionary) -> PanelContainer:
	var outer := PanelContainer.new()
	outer.custom_minimum_size = Vector2(140, 130)
	outer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	outer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	outer.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.15, 0.15, 0.2, 1)
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	outer.add_theme_stylebox_override("panel", style)

	var card := VBoxContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.size_flags_vertical = Control.SIZE_EXPAND_FILL
	outer.add_child(card)

	var name_label := Label.new()
	name_label.text = _data.get("name", level_id)
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.add_theme_color_override("font_color", Color(1, 1, 1))
	card.add_child(name_label)

	var unlocked := ProgressManager.is_level_unlocked(level_id)
	if unlocked:
		var rank := ProgressManager.get_best_rank(level_id)
		var time := ProgressManager.get_best_time(level_id)

		var rank_label := Label.new()
		rank_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		rank_label.add_theme_color_override("font_color", Color(1, 1, 1))
		if rank != "":
			rank_label.text = tr("rank") + ": " + rank
		card.add_child(rank_label)

		var time_label := Label.new()
		time_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		time_label.add_theme_color_override("font_color", Color(1, 1, 1))
		if time > 0.0:
			time_label.text = tr("best") + ": " + GameManager.format_time(time)
		else:
			time_label.text = tr("no_record")
		card.add_child(time_label)

		var play_btn := Button.new()
		play_btn.text = "play"
		play_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		play_btn.pressed.connect(func():
			GameManager.current_level = level_id
			get_tree().change_scene_to_file("res://scenes/game.tscn")
		)
		card.add_child(play_btn)
	else:
		var locked_label := Label.new()
		locked_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		locked_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
		locked_label.text = tr("locked")
		card.add_child(locked_label)

	return outer

func _on_back() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main_menu/main_menu.tscn")
