extends CanvasLayer

@onready var resume_button: Button = $Background/VBoxContainer/ResumeButton
@onready var main_menu_button: Button = $Background/VBoxContainer/MainMenuButton
@onready var settings_button: Button = $Background/VBoxContainer/SettingsButton
@onready var restart_button: Button = $Background/VBoxContainer/RestartButton
@onready var background: ColorRect = $Background

const font_size = 40

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	resume_button.add_theme_font_size_override("font_size", font_size)
	main_menu_button.add_theme_font_size_override("font_size", font_size)
	settings_button.add_theme_font_size_override("font_size", font_size)
	restart_button.add_theme_font_size_override("font_size", font_size)

	resume_button.pressed.connect(_on_resume)
	main_menu_button.pressed.connect(_on_main_menu)
	settings_button.pressed.connect(_on_settings)
	restart_button.pressed.connect(_on_restart)

	visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		var lc = get_node_or_null("/root/Game/LevelComplete")
		if lc and lc.visible:
			return
		if visible:
			resume()
		else:
			pause()
		get_viewport().set_input_as_handled()

func pause() -> void:
	show()
	get_tree().paused = true

func resume() -> void:
	hide()
	get_tree().paused = false

func _on_restart() -> void:
	hide()
	get_tree().paused = false
	LoadingScreen.reload_current_scene()

func _on_resume() -> void:
	resume()

func _on_main_menu() -> void:
	get_tree().paused = false
	LoadingScreen.switch_scene("res://scenes/menus/main_menu/main_menu.tscn")

func _on_settings() -> void:
	var settings = preload("res://scenes/menus/settings_menu/settings_menu.tscn").instantiate()
	settings.back_pressed.connect(_remove_settings)
	add_child(settings)

func _remove_settings() -> void:
	var s = get_node_or_null("SettingsMenu")
	if s:
		s.queue_free()
