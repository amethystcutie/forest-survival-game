class_name EnvironmentManager
extends Node

@export var is_static := false
@export var static_time := 9.0

@export var day_length := 8.0
@export var evening_length := 3.0
@export var night_length := 4.0
@export var day_start := 6.0

@export var fast_forward := false

@export var sun_time_day := 9.0
@export var sun_time_evening := 16.5
@export var sun_time_night := 23.0

var sun_time: float
var time: float
var day: int
var time_of_day: TimeManager.DayTime

var minutes_per_day: float
var seconds_per_day: float
var delta_multiplier: float

var day_time: float
var evening_time: float
var night_time: float

func _ready() -> void:
	Global.environment = self
	
	sun_time = sun_time_day
	time = day_start
	day = 1
	time_of_day = TimeManager.DayTime.DAY
	
	minutes_per_day = day_length + evening_length + night_length
	if fast_forward: seconds_per_day = minutes_per_day
	else: seconds_per_day = minutes_per_day * 60.0
	delta_multiplier = 24.0 / seconds_per_day
	
	day_time = day_start
	evening_time = day_length * 24.0 / minutes_per_day + day_time
	night_time = evening_length * 24.0 / minutes_per_day + evening_time
	
	print(day_time)
	print(evening_time)
	print(night_time)

func _process(delta: float) -> void:
	if is_static: 
		$Sky3D.current_time = static_time
		return
	
	# advance time
	time += delta * delta_multiplier
	
	if time >= 24.0:
		day += 1
		time = time - 24.0
	
	# update the time of day
	if time >= night_time:
		set_night()
	elif time >= evening_time:
		set_evening()
	elif time >= day_time:
		set_day()
	
	# update the global time manager
	TimeManager.time = time
	TimeManager.day = day
	if TimeManager.time_of_day != time_of_day:
		TimeManager.time_of_day = time_of_day
		TimeManager.time_advance.emit(time_of_day)
	
	# update the sky3d
	if sun_time == sun_time_day + 24.0 and $Sky3D.current_time < sun_time_day:
		sun_time = sun_time_day
		
	if $Sky3D.current_time != sun_time:
		$Sky3D.current_time = move_toward($Sky3D.current_time, sun_time, delta * 7.0)
		
func set_day() -> void:
	if time_of_day == TimeManager.DayTime.DAY: return
	time_of_day = TimeManager.DayTime.DAY
	sun_time = sun_time_day + 24.0
	
func set_evening() -> void:
	if time_of_day == TimeManager.DayTime.EVENING: return
	time_of_day = TimeManager.DayTime.EVENING
	sun_time = sun_time_evening
	
func set_night() -> void:
	if time_of_day == TimeManager.DayTime.NIGHT: return
	time_of_day = TimeManager.DayTime.NIGHT
	sun_time = sun_time_night
