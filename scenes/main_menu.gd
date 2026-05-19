extends Control

@export_file("*.tscn") var first_level_scene: String = "res://scenes/game.tscn"

@onready var play_button: Button = $VBoxContainer/PlayButton
@onready var settings_button: Button = $VBoxContainer/SettingsButton
@onready var quit_button: Button = $VBoxContainer/QuitButton


func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	Engine.time_scale = 1.0

func _on_play_pressed() -> void:
	if first_level_scene != "":
		get_tree().change_scene_to_file(first_level_scene)
	else:
		push_error("Путь к первому уровню не задан в MainMenu!")

func _on_quit_pressed() -> void:
	get_tree().quit()
