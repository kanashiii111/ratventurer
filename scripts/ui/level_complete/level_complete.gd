extends CanvasLayer

@onready var time_label: Label = $MarginContainer3/InfoVBox/TimeLabel
@onready var cheese_label: Label = $MarginContainer3/InfoVBox/CheeseLabel
@onready var new_record_label: Label = $MarginContainer3/InfoVBox/NewRecordLabel
@onready var rank_label: Label = $RankHBox/RankLabel
@onready var rank_letter_label: Label = $RankHBox/RankLetter
@onready var next_button: Button = $MarginContainer2/ButtonsVBox/NextButton
@onready var retry_button: Button = $MarginContainer2/ButtonsVBox/RetryButton
@onready var menu_button: Button = $MarginContainer/MenuButton

func _ready() -> void:
	hide()
	GameManager.level_completed.connect(_on_level_completed)

	next_button.pressed.connect(_on_next)
	retry_button.pressed.connect(_on_retry)
	menu_button.pressed.connect(_on_menu)

	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_level_completed(time: float, cheese_collected: int, cheese_total: int, rank: String, is_new_record: bool) -> void:
	time_label.text = tr("time") + ": " + GameManager.format_time(time)
	cheese_label.text = tr("cheese") + ": " + str(cheese_collected) + " / " + str(cheese_total)
	rank_label.text = tr("rank") + ":"
	rank_letter_label.text = rank
	new_record_label.text = tr("new_record")

	new_record_label.visible = is_new_record

	var next_id: String = GameManager.LEVEL_DATA[GameManager.current_level]["next"]
	next_button.visible = next_id != ""

	show()
	get_tree().paused = true

func _on_next() -> void:
	get_tree().paused = false
	GameManager.load_next_level()

func _on_retry() -> void:
	get_tree().paused = false
	GameManager.restart_level()

func _on_menu() -> void:
	get_tree().paused = false
	LoadingScreen.switch_scene("res://scenes/menus/main_menu/main_menu.tscn")
