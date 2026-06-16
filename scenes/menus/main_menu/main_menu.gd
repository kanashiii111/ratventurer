extends Control

@export_file("*.tscn") var first_level_scene: String = "res://scenes/game.tscn"

@onready var play_button: Button = $VBoxContainer/PlayButton
@onready var settings_button: Button = $VBoxContainer/SettingsButton
@onready var quit_button: Button = $VBoxContainer/QuitButton


const font_size = 40

func _ready() -> void:
	play_button.add_theme_font_size_override("font_size", font_size)
	settings_button.add_theme_font_size_override("font_size", font_size)
	quit_button.add_theme_font_size_override("font_size", font_size)

	play_button.pressed.connect(_on_play_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	Engine.time_scale = 1.0

func _on_settings_pressed() -> void:
	var settings = preload("res://scenes/menus/settings_menu/settings_menu.tscn").instantiate()
	settings.back_pressed.connect(_remove_settings)
	add_child(settings)

func _remove_settings() -> void:
	var s = get_node_or_null("SettingsMenu")
	if s:
		s.queue_free()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/level_select/level_select.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
