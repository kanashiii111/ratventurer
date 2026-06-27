extends Node

signal time_updated(time: float)
signal cheese_changed(collected: int, total: int)
signal level_completed(time: float, cheese_collected: int, cheese_total: int, rank: String, is_new_record: bool)

var current_level: String = ""
var elapsed_time: float = 0.0
var cheese_collected: int = 0
var cheese_total: int = 0
var is_completed: bool = false

var _checkpoint_position: Vector2 = Vector2.ZERO
var _has_checkpoint: bool = false

const LEVEL_DATA := {
	"level_tutorial": {
		"name": "Tutorial",
		"next": "level_1",
		"scene": "res://scenes/levels/level_tutorial.tscn",
		"music": preload("res://assets/sounds/music/tutorial.mp3"),
		"time_s": 15.0,
		"time_a": 17.0,
		"time_b": 20.0
	},
	"level_1": {
		"name": "Castle",
		"next": "level_2",
		"scene": "res://scenes/levels/level_1.tscn",
		"music": preload("res://assets/sounds/music/emmraan-action-fighting-theme-background-motivate-retro-518719.mp3"),
		"time_s": 20.0,
		"time_a": 25.0,
		"time_b": 35.0
	},
	"level_2": {
		"name": "Free",
		"next": "",
		"scene": "res://scenes/levels/level_2.tscn",
		"music": preload("res://assets/sounds/music/emmraan-enemies-270516.mp3"),
		"time_s": 20.0,
		"time_a": 25.0,
		"time_b": 35.0
	},
}

func start_level(level_id: String) -> void:
	current_level = level_id
	elapsed_time = 0.0
	cheese_collected = 0
	cheese_total = 0
	is_completed = false
	_has_checkpoint = false
	_checkpoint_position = Vector2.ZERO
	time_updated.emit(0.0)
	cheese_changed.emit(0, 0)

func collect_cheese() -> void:
	if is_completed:
		return
	cheese_collected += 1
	cheese_changed.emit(cheese_collected, cheese_total)

func set_cheese_total(total: int) -> void:
	cheese_total = total
	cheese_changed.emit(cheese_collected, cheese_total)

func complete_level() -> void:
	if is_completed:
		return
	is_completed = true

	var cheese_ratio := float(cheese_collected) / float(cheese_total) if cheese_total > 0 else 1.0
	var rank := _calculate_rank(elapsed_time, cheese_ratio)

	var prev_time := ProgressManager.get_best_time(current_level)
	var prev_rank := ProgressManager.get_best_rank(current_level)
	var is_new_record := _is_new_best(prev_time, prev_rank, elapsed_time, rank)

	if is_new_record:
		ProgressManager.set_best_time(current_level, elapsed_time)
		ProgressManager.set_best_rank(current_level, rank)

	var next_id: String = LEVEL_DATA[current_level]["next"]
	if next_id != "" and not ProgressManager.is_level_unlocked(next_id):
		ProgressManager.unlock_level(next_id)

	ProgressManager.save_progress()
	level_completed.emit(elapsed_time, cheese_collected, cheese_total, rank, is_new_record)


static func _is_new_best(prev_time: float, prev_rank: String, new_time: float, new_rank: String) -> bool:
	if prev_time == 0.0 or prev_rank == "":
		return true

	var order := ["S", "A", "B", "C"]
	var prev_idx: int = order.find(prev_rank)
	var new_idx: int = order.find(new_rank)

	if new_idx < prev_idx:
		return true

	if new_idx == prev_idx and new_time < prev_time:
		return true

	return false

func _calculate_rank(time: float, cheese_ratio: float) -> String:
	var data = LEVEL_DATA.get(current_level, LEVEL_DATA["level_tutorial"])

	var time_rank := "C"
	if time <= data["time_s"]:
		time_rank = "S"
	elif time <= data["time_a"]:
		time_rank = "A"
	elif time <= data["time_b"]:
		time_rank = "B"

	var cheese_rank := "C"
	if cheese_ratio >= 1.0:
		cheese_rank = "S"
	elif cheese_ratio >= 0.8:
		cheese_rank = "A"
	elif cheese_ratio >= 0.5:
		cheese_rank = "B"

	var order := ["S", "A", "B", "C"]
	var time_idx := order.find(time_rank)
	var cheese_idx := order.find(cheese_rank)
	
	var rank_idx = ceili(time_idx + cheese_idx / 2.0)
	if rank_idx >= 3: return "C"
	return order[rank_idx]

func restart_level() -> void:
	LoadingScreen.reload_current_scene()

func load_next_level() -> void:
	var next_id: String = LEVEL_DATA[current_level]["next"]
	if next_id != "":
		current_level = next_id
		LoadingScreen.switch_scene("res://scenes/game.tscn")

func format_time(seconds: float) -> String:
	var total_ms: int = int(seconds * 100)
	var m: int = total_ms / 6000
	var s: int = (total_ms / 100) % 60
	var ms: int = total_ms % 100
	return "%02d:%02d.%02d" % [m, s, ms]

func set_checkpoint(position: Vector2) -> void:
	print(position)
	_checkpoint_position = position
	_has_checkpoint = true

func clear_checkpoint() -> void:
	_has_checkpoint = false
	_checkpoint_position = Vector2.ZERO

func has_checkpoint() -> bool:
	return _has_checkpoint

func get_checkpoint_position() -> Vector2:
	return _checkpoint_position
