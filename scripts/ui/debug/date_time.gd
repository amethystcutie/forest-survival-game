extends Control

func _process(_delta: float) -> void:
	$Label.text = "day %s, time: %s (%s)" % [
		TimeManager.day,
		TimeManager.time_24h,
		str(TimeManager.DayTime.find_key(TimeManager.time_of_day)).to_lower()
	]
	
	$DayClock/TextureRect.rotation = TimeManager.time * TAU / 24.0
