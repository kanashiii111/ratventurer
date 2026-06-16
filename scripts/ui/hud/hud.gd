extends CanvasLayer

@onready var time_label: Label = $TimeLabel
@onready var cheese_label: Label = $CheeseLabel
@onready var best_time_label: Label = $BestTimeLabel

func _ready() -> void:
	GameManager.time_updated.connect(_on_time_updated)
	GameManager.cheese_changed.connect(_on_cheese_changed)

	var best := ProgressManager.get_best_time(GameManager.current_level)
	if best > 0.0:
		best_time_label.text = tr("best") + ": " + GameManager.format_time(best)
	else:
		best_time_label.text = ""

func _on_time_updated(time: float) -> void:
	time_label.text = GameManager.format_time(time)

func _on_cheese_changed(collected: int, total: int) -> void:
	cheese_label.text = str(collected) + " / " + str(total)
