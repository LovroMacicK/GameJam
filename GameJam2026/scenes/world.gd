class_name World extends Node2D

# Warm autumn: #E8C9A3
# Cozy autumn: #D9B18C

const DAY_COLOR: Color = Color("#E8C9A3")
const NIGHT_COLOR: Color = Color("222642")

const DAY_LENGTH: float = 110.0
const TRANSITION_LENGTH: float = 10.0
const NIGHT_LENGTH: float = 170.0

@onready var day_timer: Timer = $DayTimer
@onready var night_timer: Timer = $NightTimer
@onready var canvas_modulator: CanvasModulate = $CanvasModulate
@onready var player_lamp: PointLight2D = $player/Lamp

@export var day_label: Label
@export var time_label: Label

var day_count: int
var elapsed_time: float

var start_day_to_night_transition: bool
var start_night_to_day_transition: bool
var transition_timer: Timer

enum Stages {
	DAWN,
	DAY,
	DUSK,
	NIGHT,
}

var current_stage: Stages


func _ready() -> void:
	canvas_modulator.color = DAY_COLOR
	current_stage = Stages.DAY
	day_count = 1
	elapsed_time = 0.0

	change_time_label("06:00")
	change_day_label(day_count)


func _process(delta: float) -> void:
	elapsed_time += delta

	if elapsed_time >= 300.0:
		elapsed_time -= 300.0
		start_transition_to_day()

	elif elapsed_time >= DAY_LENGTH + TRANSITION_LENGTH + NIGHT_LENGTH:
		if current_stage != Stages.DAWN:
			current_stage = Stages.DAWN
			start_transition_to_day()

	elif elapsed_time >= DAY_LENGTH + TRANSITION_LENGTH:
		current_stage = Stages.NIGHT

	elif elapsed_time >= DAY_LENGTH:
		if current_stage != Stages.DUSK:
			current_stage = Stages.DUSK
			print("DUSK")
			start_transition_to_night()

	else:
		current_stage = Stages.DAY
		day_count += 1

	change_time_label(update_time(elapsed_time))


func update_time(time: float) -> String:
	var game_minutes: float = 0.0

	match current_stage:
		Stages.DAY:
			game_minutes = 360.0 + time * 6.0

		Stages.DUSK:
			game_minutes = 1020.0 + (time - 110.0) * 6.0

		Stages.NIGHT:
			game_minutes = 1080.0 + (time - 120.0) * (660.0 / 170.0)

		Stages.DAWN:
			game_minutes = 300.0 + (time - 290.0) * 6.0

	game_minutes = fposmod(game_minutes, 1440.0)

	var hours: int = int(game_minutes) / 60
	var minutes: int = int(game_minutes) % 60

	return "%02d:%02d" % [hours, minutes]


func start_transition_to_night() -> void:
	print("NIGHT")
	start_day_to_night_transition = true
	start_night_to_day_transition = false
	var tween: Tween = create_tween()
	tween.tween_property(canvas_modulator, "color", NIGHT_COLOR, TRANSITION_LENGTH)
	tween.tween_property(player_lamp, "energy", 3.0, TRANSITION_LENGTH)


func start_transition_to_day() -> void:
	start_night_to_day_transition = true
	start_day_to_night_transition = false
	var tween: Tween = create_tween()
	tween.tween_property(canvas_modulator, "color", DAY_COLOR, TRANSITION_LENGTH)
	tween.tween_property(player_lamp, "energy", 0.0, TRANSITION_LENGTH)


func change_time_label(time: String) -> void:
	time_label.text = time


func change_day_label(day: int) -> void:
	day_label.text = "Day: " + str(day)


func _on_day_timer_timeout() -> void:
	start_transition_to_night()


func _on_night_timer_timeout() -> void:
	start_transition_to_day()
