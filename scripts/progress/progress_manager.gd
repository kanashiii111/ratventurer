extends Node

var SAVE_PATH: String

var _data: Dictionary = {}

func _ready() -> void:
	if OS.has_feature("editor"):
		SAVE_PATH = ProjectSettings.globalize_path("user://") + "progress.cfg"
	else:
		SAVE_PATH = OS.get_executable_path().get_base_dir() + "/progress.cfg"
	load_progress()

func load_progress() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		_init_defaults()
		return

	for section in cfg.get_sections():
		_data[section] = {
			"best_time": cfg.get_value(section, "best_time", 0.0),
			"best_rank": cfg.get_value(section, "best_rank", ""),
			"unlocked": cfg.get_value(section, "unlocked", false)
		}

func save_progress() -> void:
	var cfg := ConfigFile.new()
	for level_id in _data:
		cfg.set_value(level_id, "best_time", _data[level_id]["best_time"])
		cfg.set_value(level_id, "best_rank", _data[level_id]["best_rank"])
		cfg.set_value(level_id, "unlocked", _data[level_id]["unlocked"])
	cfg.save(SAVE_PATH)

func _init_defaults() -> void:
	_data = {
		"level_tutorial": { "best_time": 0.0, "best_rank": "", "unlocked": true },
		"level_1": { "best_time": 0.0, "best_rank": "", "unlocked": true },
		"level_2": { "best_time": 0.0, "best_rank": "", "unlocked": false },
	}

func is_level_unlocked(level_id: String) -> bool:
	return _data.get(level_id, {}).get("unlocked", false)

func unlock_level(level_id: String) -> void:
	if not _data.has(level_id):
		_data[level_id] = { "best_time": 0.0, "best_rank": "", "unlocked": false }
	_data[level_id]["unlocked"] = true

func get_best_time(level_id: String) -> float:
	return _data.get(level_id, {}).get("best_time", 0.0)

func set_best_time(level_id: String, time: float) -> bool:
	if not _data.has(level_id):
		_data[level_id] = { "best_time": 0.0, "best_rank": "", "unlocked": false }
	var current: float = _data[level_id]["best_time"]
	if current == 0.0 or time < current:
		_data[level_id]["best_time"] = time
		return true
	return false

func get_best_rank(level_id: String) -> String:
	return _data.get(level_id, {}).get("best_rank", "")

func set_best_rank(level_id: String, rank: String) -> void:
	if not _data.has(level_id):
		_data[level_id] = { "best_time": 0.0, "best_rank": "", "unlocked": false }
	_data[level_id]["best_rank"] = rank
