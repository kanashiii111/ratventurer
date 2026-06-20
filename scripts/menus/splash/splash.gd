extends Control

@onready var label: Label = $VBoxContainer/Label

func _ready() -> void:
	label.text = tr("loading")
	await RenderingServer.frame_post_draw
	get_tree().change_scene_to_file("res://scenes/menus/main_menu/main_menu.tscn")
