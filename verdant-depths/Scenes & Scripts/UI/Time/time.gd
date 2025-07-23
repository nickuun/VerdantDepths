extends Control

@onready var label: Label = $TimeLabel

var total_elapsed_time := 0.0  # Real seconds passed in-game

func _ready():
	update_display()
	TimeManager.connect("time_changed", Callable(self, "update_display"))

func update_display():
	var time_str = TimeManager.get_formatted_time()
	var day_str = TimeManager.get_day_of_week()
	var date_str = TimeManager.get_formatted_date()

	label.text = "%s - %s, %s" % [date_str, day_str, time_str]
