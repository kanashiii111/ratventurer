class_name PlayerDeathState extends PlayerState

var fade: ColorRect
var _has_died: bool = false
var _last_frame: int = -1
@export var death_audio_2: AudioStream
@export var death_audio_1: AudioStream

func enter():
	if _has_died:
		return
	_has_died = true
	_last_frame = -1

	player.velocity = Vector2.ZERO
	player.collision_layer = 0
	player.set_physics_process(false)
	player.anim_player.play("Death")

	var canvas := CanvasLayer.new()
	canvas.layer = 128
	fade = ColorRect.new()
	fade.color = Color.BLACK
	fade.modulate = Color.TRANSPARENT
	fade.size = get_viewport().get_visible_rect().size
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas.add_child(fade)
	get_tree().current_scene.add_child(canvas)

	var tween = create_tween()
	tween.tween_interval(1.0)
	tween.tween_property(fade, "modulate", Color.BLACK, 0.5)
	tween.tween_callback(func():
		GameManager.restart_level()
	)

func exit():
	_has_died = false

func handle_input(_event: InputEvent) -> PlayerState:
	return null

func process(_delta: float) -> PlayerState:
	var current_frame: int = player.sprite.frame
	if current_frame >= 32 and current_frame != _last_frame:
		_last_frame = current_frame
		player.play_oneshot_sfx(death_audio_1) if current_frame == 32 else player.play_oneshot_sfx(death_audio_2)
	return null

func physics_process(_delta: float) -> PlayerState:
	return null
