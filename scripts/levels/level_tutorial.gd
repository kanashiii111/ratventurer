extends Area2D

@onready var popup: Node2D = $"../../Popup"
@export var message_key: String

@onready var cheese: Area2D = $"../../../Cheese/Cheese2"

var popup_pos = {
	"wasd_popup": Vector2(15.0, -69.0),
	"jump_popup": Vector2(180.0, -70),
	"slide_popup": Vector2(372.0, -104.0),
	"dash_popup": Vector2(670.0, -104.0),
	"attack_popup": Vector2(906.0, -190.0),
	"slam_popup": Vector2(1100.0, -168.0),
	"double_jump_popup": Vector2(1255.0, 92.0)
}

func _ready() -> void:
	if is_instance_valid(cheese):
		cheese.monitoring = false
		cheese.visible = false

func _process(_delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if message_key == "double_jump_popup":
			if is_instance_valid(cheese):
				cheese.monitoring = true
				cheese.visible = true
		popup.position = Vector2(popup_pos[message_key])
		popup.show_text(message_key)

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		popup.hide_text()
