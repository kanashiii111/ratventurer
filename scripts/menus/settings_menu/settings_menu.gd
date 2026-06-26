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
@onready var attack_label: Label = $TabContainer/Controls/ControlsRow/AttackLabel
@onready var attack_rebind_button: Button = $TabContainer/Controls/ControlsRow/AttackRebindButton
@onready var slide_label: Label = $TabContainer/Controls/SlideRow/SlideLabel
@onready var slide_rebind_button: Button = $TabContainer/Controls/SlideRow/SlideRebindButton
@onready var dash_label: Label = $TabContainer/Controls/DashRow/DashLabel
@onready var dash_rebind_button: Button = $TabContainer/Controls/DashRow/DashRebindButton
@onready var ground_slam_label: Label = $TabContainer/Controls/GroundSlamRow/GroundSlamLabel
@onready var ground_slam_rebind_button: Button = $TabContainer/Controls/GroundSlamRow/GroundSlamRebindButton
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
	attack = $TabContainer/Controls/ControlsRow/AttackLabel,
	slide = $TabContainer/Controls/SlideRow/SlideLabel,
	dash = $TabContainer/Controls/DashRow/DashLabel,
	ground_slam = $TabContainer/Controls/GroundSlamRow/GroundSlamLabel,
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
		controls = "Управление",
		attack = "Атака",
		slide = "Скольжение",
		dash = "Рывок",
		ground_slam = "Удар по земле",
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
		controls = "Controls",
		attack = "Attack",
		slide = "Slide",
		dash = "Dash",
		ground_slam = "Ground Slam",
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

	var control_labels := [attack_label, slide_label, dash_label, ground_slam_label]
	for label: Label in control_labels:
		label.add_theme_font_size_override("font_size", label_size)
		label.custom_minimum_size.x = 400
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		label.add_theme_constant_override("margin_left", 100)

	for row_path in [
		"ControlsRow",
		"SlideRow",
		"DashRow",
		"GroundSlamRow",
	]:
		var s = $TabContainer/Controls.get_node(row_path + "/Spacer")
		s.custom_minimum_size.x = 20
		s.mouse_filter = Control.MOUSE_FILTER_IGNORE

	_rebind_buttons = {
		"Attack": attack_rebind_button,
		"Slide": slide_rebind_button,
		"Dash": dash_rebind_button,
		"GroundSlam": ground_slam_rebind_button,
	}
	for action in _rebind_buttons:
		var btn = _rebind_buttons[action]
		btn.add_theme_font_size_override("font_size", control_size)
		btn.text = _get_action_key_name(action)
		btn.pressed.connect(_on_rebind_pressed.bind(action))

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
	SettingsManager.controls_changed.connect(_on_controls_changed)


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
	tab_container.set_tab_title(3, lang.controls)

	for key in labels:
		labels[key].text = lang.get(key, key)

	ru_button.text = lang.russian
	en_button.text = lang.english


var _rebinding_action: String = ""
var _rebind_buttons: Dictionary = {}


func _on_back() -> void:
	sfx_player.play()
	back_pressed.emit()


func _on_rebind_pressed(action: String) -> void:
	_rebinding_action = action
	_rebind_buttons[action].text = "..."
	sfx_player.play()


func _on_controls_changed(action: String) -> void:
	if _rebind_buttons.has(action):
		_rebind_buttons[action].text = _get_action_key_name(action)


func _input(event: InputEvent) -> void:
	if _rebinding_action != "":
		if event is InputEventKey:
			if not event.pressed:
				return
			if event.keycode == KEY_ESCAPE:
				var btn = _rebind_buttons[_rebinding_action]
				btn.text = _get_action_key_name(_rebinding_action)
				_rebinding_action = ""
				get_viewport().set_input_as_handled()
				return
		elif event is InputEventMouseButton:
			if not event.pressed or event.button_index == MOUSE_BUTTON_LEFT:
				return
		else:
			return

		SettingsManager.set_action_event(_rebinding_action, event)
		_rebinding_action = ""
		get_viewport().set_input_as_handled()
		return

	if event.is_action_pressed("Pause"):
		back_pressed.emit()
		get_viewport().set_input_as_handled()


func _on_tab_container_tab_clicked(_tab: int) -> void:
	sfx_player.play()


func _get_action_key_name(action: String) -> String:
	var events = InputMap.action_get_events(action)
	if events.is_empty():
		return "..."
	var event = events[0]
	if event is InputEventKey:
		var code = event.keycode if event.keycode != 0 else event.physical_keycode
		return OS.get_keycode_string(code)
	elif event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				return "LMB"
			MOUSE_BUTTON_RIGHT:
				return "RMB"
			MOUSE_BUTTON_MIDDLE:
				return "MMB"
			_:
				return "Mouse %d" % event.button_index
	return "?"
