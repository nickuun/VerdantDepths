extends Node

signal time_changed

const TICK_INTERVAL := 7.0  # seconds per 10 in-game minutes

var minute := 0
var hour := 6  # Start at 6 AM
var day := 1
var year := 1

const DAYS_OF_WEEK := ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

var time_passed := 0.0

func _process(delta: float) -> void:
	time_passed += (delta * 1)
	if time_passed >= TICK_INTERVAL:
		time_passed = 0
		advance_time()

func advance_time():
	minute += 10
	if minute >= 60:
		minute = 0
		hour += 1

	# Roll over at 30 (6 AM to 5:50 AM = 24h)
	if hour >= 24:
		hour = 6
		day += 1

	if day > 365:
		day = 1
		year += 1

	emit_signal("time_changed")



func get_formatted_time() -> String:
	return "%02d:%02d" % [hour, minute]

func get_day_of_week() -> String:
	var index = (day - 1) % 7
	return DAYS_OF_WEEK[index]

func get_formatted_date() -> String:
	return "Day %d" % day  # Year is tracked, not shown
