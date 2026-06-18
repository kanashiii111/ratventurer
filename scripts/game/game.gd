extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var level_container: Node2D = $LevelContainer
@onready var hud: CanvasLayer = $HUD
@onready var level_complete: CanvasLayer = $LevelComplete
@onready var pause_menu: CanvasLayer = $PauseMenu

var player_in_exit: bool = false
var label: Label

func _ready() -> void:
	var level_id: String = GameManager.current_level
	if level_id == "":
		level_id = "level_1"
		GameManager.current_level = level_id
	
	label = player.get_node_or_null("Label")
	if not label: return

	GameManager.start_level(level_id)

	var level_path: String = GameManager.LEVEL_DATA[level_id]["scene"]
	var level: Node = load(level_path).instantiate()
	level_container.add_child(level)

	var spawn: Marker2D = level.get_node_or_null("PlayerSpawn")
	if spawn:
		player.global_position = spawn.global_position

	await get_tree().process_frame
	var cheeses: Array[Node] = get_tree().get_nodes_in_group("cheese")
	GameManager.set_cheese_total(cheeses.size())

	var exit_zone: Area2D = level.get_node_or_null("ExitZone")
	if exit_zone:
		exit_zone.body_entered.connect(_on_exit_zone_body_entered)
		exit_zone.body_exited.connect(_on_exit_zone_body_exited)
	_set_camera_limits(level)

func _set_camera_limits(level: Node) -> void:
	var level_layers: Node2D = level.get_node_or_null("LevelLayers")
	if not level_layers:
		return

	var ground: TileMapLayer = level_layers.get_node_or_null("Layer1")
	if not ground or not ground.tile_set:
		return

	var used_rect: Rect2i = ground.get_used_rect()
	if used_rect.size == Vector2i.ZERO:
		return

	var tile_size := ground.tile_set.tile_size
	var map_pos := ground.global_position

	var camera: Camera2D = player.get_node("camera")
	camera.limit_top = -300#int(map_pos.y + used_rect.position.y * tile_size.y)
	#print(camera.limit_top)
	camera.limit_left   = int(map_pos.x + used_rect.position.x * tile_size.x)
	camera.limit_right  = int(map_pos.x + (used_rect.position.x + used_rect.size.x) * tile_size.x)
	#camera.limit_bottom = 100 #int(map_pos.y + (used_rect.position.y + used_rect.size.y) * tile_size.y)

func _on_exit_zone_body_entered(body: Node2D) -> void:
	if body == player:
		player_in_exit = true
		label.text = tr("interact")

func _on_exit_zone_body_exited(body: Node2D) -> void:
	if body == player:
		player_in_exit = false
		label.text = ""

func _process(delta: float) -> void:
	if not GameManager.is_completed and not get_tree().paused:
		GameManager.elapsed_time += delta
		GameManager.time_updated.emit(GameManager.elapsed_time)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Restart"):
		GameManager.restart_level()
	if event.is_action_pressed("Interact") and player_in_exit and not GameManager.is_completed:
		GameManager.complete_level()
