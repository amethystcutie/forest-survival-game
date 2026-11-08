extends Node

var time: float = 0.0
var day: int = 1

var time_of_day: DayTime = DayTime.DAY

var time_24h: String: 
	get: return float_to_24h(time)

enum DayTime {
	DAY, EVENING, NIGHT
}

signal time_advance(day_time: DayTime)

func float_to_24h(timestamp: float) -> String:
	var hours = int(timestamp)
	var minutes = round((timestamp - hours) * 60)
	if minutes == 60:
		hours += 1
		minutes = 0
		
	return str("%02d" % hours, ":", "%02d" % minutes)
	
