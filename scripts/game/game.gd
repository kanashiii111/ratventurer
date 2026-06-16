extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var level_container: Node2D = $LevelContainer
@onready var hud: CanvasLayer = $HUD
@onready var level_complete: CanvasLayer = $LevelComplete
@onready var pause_menu: CanvasLayer = $PauseMenu

func _ready() -> void:
	var level_id: String = GameManager.current_level
	if level_id == "":
		level_id = "level_1"
		GameManager.current_level = level_id

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

func _on_exit_zone_body_entered(body: Node2D) -> void:
	if body == player:
		GameManager.complete_level()

func _process(delta: float) -> void:
	if not GameManager.is_completed and not get_tree().paused:
		GameManager.elapsed_time += delta
		GameManager.time_updated.emit(GameManager.elapsed_time)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Restart"):
		GameManager.restart_level()
