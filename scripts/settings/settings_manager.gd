extends Node

var master_volume: float = 1.0 :
	set(value):
		master_volume = value
		save()
		master_volume_changed.emit(value)
		var idx = AudioServer.get_bus_index("Master")
		if idx >= 0:
			AudioServer.set_bus_volume_db(idx, linear_to_db(_clamp_volume(value)))

var music_volume: float = 1.0 :
	set(value):
		music_volume = value
		save()
		music_volume_changed.emit(value)
		var idx = AudioServer.get_bus_index("Music")
		if idx >= 0:
			AudioServer.set_bus_volume_db(idx, linear_to_db(_clamp_volume(value)))

var sfx_volume: float = 1.0 :
	set(value):
		sfx_volume = value
		save()
		sfx_volume_changed.emit(value)
		var idx = AudioServer.get_bus_index("SFX")
		if idx >= 0:
			AudioServer.set_bus_volume_db(idx, linear_to_db(_clamp_volume(value)))

var fullscreen: bool = false :
	set(value):
		fullscreen = value
		save()
		fullscreen_changed.emit(value)
		DisplayServer.window_set_mode(
			DisplayServer.WINDOW_MODE_FULLSCREEN if value else DisplayServer.WINDOW_MODE_WINDOWED
		)

var language: String = "ru" :
	set(value):
		language = value
		save()
		language_changed.emit(value)
		TranslationServer.set_locale(value)

signal master_volume_changed(value: float)
signal music_volume_changed(value: float)
signal sfx_volume_changed(value: float)
signal fullscreen_changed(value: bool)
signal language_changed(locale: String)

const SAVE_PATH: String = "user://settings.cfg"


func _ready() -> void:
	_setup_audio_buses()
	load_settings()
	apply_all()


func _setup_audio_buses() -> void:
	if AudioServer.get_bus_index("Music") == -1:
		AudioServer.add_bus()
		AudioServer.set_bus_name(AudioServer.get_bus_count() - 1, "Music")

	if AudioServer.get_bus_index("SFX") == -1:
		AudioServer.add_bus()
		AudioServer.set_bus_name(AudioServer.get_bus_count() - 1, "SFX")


func load_settings() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return

	master_volume = cfg.get_value("audio", "master_volume", 1.0)
	music_volume = cfg.get_value("audio", "music_volume", 1.0)
	sfx_volume = cfg.get_value("audio", "sfx_volume", 1.0)
	fullscreen = cfg.get_value("display", "fullscreen", false)
	language = cfg.get_value("locale", "language", "ru")


func save() -> void:
	var cfg := ConfigFile.new()

	cfg.set_value("audio", "master_volume", master_volume)
	cfg.set_value("audio", "music_volume", music_volume)
	cfg.set_value("audio", "sfx_volume", sfx_volume)
	cfg.set_value("display", "fullscreen", fullscreen)
	cfg.set_value("locale", "language", language)

	cfg.save(SAVE_PATH)


func apply_all() -> void:
	master_volume_changed.emit(master_volume)
	music_volume_changed.emit(music_volume)
	sfx_volume_changed.emit(sfx_volume)
	fullscreen_changed.emit(fullscreen)
	language_changed.emit(language)


func _clamp_volume(v: float) -> float:
	return maxf(v, 0.001)
