extends Control

signal back_pressed

@onready var sfx_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var button_audio: AudioStream

@onready var tab_container: TabContainer = $TabContainer
@onready var master_slider: HSlider = $TabContainer/Sound/MasterRow/MasterSlider
@onready var music_slider: HSlider = $TabContainer/Sound/MusicRow/MusicSlider
@onready var sfx_slider: HSlider = $TabContainer/Sound/SfxRow/SfxSlider
@onready var fullscreen_checkbox: CheckBox = $TabContainer/General/GeneralRow/FullscreenCheckBox
@onready var ru_button: Button = $TabContainer/Language/LanguageRow/RuButton
@onready var en_button: Button = $TabContainer/Language/LanguageRow/EnButton
@onready var back_button: Button = $MarginContainer/BackButton
@onready var master_percent: Label = $TabContainer/Sound/MasterRow/Label
@onready var music_percent: Label = $TabContainer/Sound/MusicRow/Label
@onready var sfx_percent: Label = $TabContainer/Sound/SfxRow/Label

@onready var labels := {
	fullscreen = $TabContainer/General/GeneralRow/FullscreenLabel,
	master_volume = $TabContainer/Sound/MasterRow/MasterLabel,
	music = $TabContainer/Sound/MusicRow/MusicLabel,
	sfx = $TabContainer/Sound/SfxRow/SfxLabel,
	language = $TabContainer/Language/LanguageRow/LanguageLabel,
	back = $MarginContainer/BackButton,
}

const strings := {
	ru = {
		general = "Основные",
		sound = "Звук",
		language = "Язык",
		master_volume = "Общая громкость",
		music = "Музыка",
		sfx = "Звуки",
		fullscreen = "Полноэкранный режим",
		back = "Назад",
		russian = "Русский",
		english = "Английский",
	},
	en = {
		general = "General",
		sound = "Sound",
		language = "Language",
		master_volume = "Master Volume",
		music = "Music",
		sfx = "SFX",
		fullscreen = "Fullscreen",
		back = "Back",
		russian = "Russian",
		english = "English",
	},
}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	var label_size: int = 64
	var control_size: int = 50
	var tab_size: int = 26
	var back_size: int = 28
	
	sfx_player.stream = button_audio
	
	master_percent.text = str(int(SettingsManager.master_volume * 100)) + "%"
	music_percent.text = str(int(SettingsManager.music_volume * 100)) + "%"
	sfx_percent.text = str(int(SettingsManager.sfx_volume * 100)) + "%"
	
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.25, 0.25, 0.25)
	tab_container.add_theme_stylebox_override("panel", panel_style)
	tab_container.add_theme_font_size_override("font_size", tab_size)
	
	back_button.add_theme_font_size_override("font_size", back_size)

	master_slider.min_value = 0.0
	master_slider.max_value = 1.0
	master_slider.step = 0.01
	master_slider.value = SettingsManager.master_volume
	master_slider.custom_minimum_size = Vector2(400, 30)
	

	music_slider.min_value = 0.0
	music_slider.max_value = 1.0
	music_slider.step = 0.01
	music_slider.value = SettingsManager.music_volume
	music_slider.custom_minimum_size = Vector2(400, 30)

	sfx_slider.min_value = 0.0
	sfx_slider.max_value = 1.0
	sfx_slider.step = 0.01
	sfx_slider.value = SettingsManager.sfx_volume
	sfx_slider.custom_minimum_size = Vector2(400, 30)
	
	fullscreen_checkbox.add_theme_font_size_override("font_size", control_size)
	fullscreen_checkbox.button_pressed = SettingsManager.fullscreen
	
	for node: Control in [
		$TabContainer/Sound/MasterRow/Spacer,
		$TabContainer/Sound/MusicRow/Spacer,
		$TabContainer/Sound/SfxRow/Spacer,
		$TabContainer/General/GeneralRow/Spacer,
		$TabContainer/Language/LanguageRow/Spacer
	]:
		node.custom_minimum_size.x = 20
		node.mouse_filter = Control.MOUSE_FILTER_IGNORE

	for node: Label in [
		$TabContainer/Sound/MasterRow/MasterLabel,
		$TabContainer/Sound/MusicRow/MusicLabel,
		$TabContainer/Sound/SfxRow/SfxLabel,
		$TabContainer/General/GeneralRow/FullscreenLabel,
		$TabContainer/Language/LanguageRow/LanguageLabel,
	]:
		node.add_theme_font_size_override("font_size", label_size)
		node.custom_minimum_size.x = 400
		node.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		node.add_theme_constant_override("margin_left", 100)

	for node: Button in [ru_button, en_button]:
		node.add_theme_font_size_override("font_size", control_size)
		var button_theme_4 = preload("res://assets/sprites/ui/button_4.tres")
		var button_theme_5 = preload("res://assets/sprites/ui/button_5.tres")
		if node == ru_button: node.theme = button_theme_4
		else: node.theme = button_theme_5

	_update_language_buttons()
	_update_translations()

	master_slider.value_changed.connect(func(v):
		SettingsManager.master_volume = v
		master_percent.text = str(int(v * 100)) + "%"
	)
	
	music_slider.value_changed.connect(func(v): 
		SettingsManager.music_volume = v
		music_percent.text = str(int(v * 100)) + "%"
	)
	
	sfx_slider.value_changed.connect(func(v):
		SettingsManager.sfx_volume = v
		sfx_percent.text = str(int(v * 100)) + "%"
	)
	
	fullscreen_checkbox.toggled.connect(func(v): SettingsManager.fullscreen = v)

	ru_button.pressed.connect(func(): SettingsManager.language = "ru")
	en_button.pressed.connect(func(): SettingsManager.language = "en")
	back_button.pressed.connect(_on_back)

	SettingsManager.language_changed.connect(_on_language_changed)


func _on_language_changed(_locale: String) -> void:
	sfx_player.play()
	_update_language_buttons()
	_update_translations()


func _update_language_buttons() -> void:
	ru_button.disabled = SettingsManager.language == "ru"
	en_button.disabled = SettingsManager.language == "en"


func _update_translations() -> void:
	var lang = strings.get(SettingsManager.language, strings.ru)

	tab_container.set_tab_title(0, lang.general)
	tab_container.set_tab_title(1, lang.sound)
	tab_container.set_tab_title(2, lang.language)

	for key in labels:
		labels[key].text = lang.get(key, key)

	ru_button.text = lang.russian
	en_button.text = lang.english


func _on_back() -> void:
	sfx_player.play()
	back_pressed.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		back_pressed.emit()
		get_viewport().set_input_as_handled()

func _on_tab_container_tab_clicked(_tab: int) -> void:
	sfx_player.play()
