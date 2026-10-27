class_name World extends Node2D

const DAY_COLOR: Color = Color("#E8C9A3")
const NIGHT_COLOR: Color = Color("#222642")

const DAY_LENGTH: float = 55.0
const TRANSITION_LENGTH: float = 10.0
const NIGHT_LENGTH: float = 85.0

const TOTAL_LENGTH: float = DAY_LENGTH + NIGHT_LENGTH + TRANSITION_LENGTH * 2.0

@onready var canvas_modulator: CanvasModulate = $CanvasModulate
@onready var player_lamp: PointLight2D = $player/Lamp

@export var day_label: Label
@export var time_label: Label

var day_count: int = 1
var elapsed_time: float = 0.0

var current_tween: Tween

enum Stages {
	DAWN,
	DAY,
	DUSK,
	NIGHT,
}

var current_stage: Stages = Stages.DAY


func _ready() -> void:
	canvas_modulator.color = DAY_COLOR
	player_lamp.energy = 0.0

	change_day_label(day_count)
	change_time_label(update_time(elapsed_time))


func _process(delta: float) -> void:
	elapsed_time += delta

	# Začetek novega dneva
	if elapsed_time >= TOTAL_LENGTH:
		elapsed_time = fposmod(elapsed_time, TOTAL_LENGTH)
		day_count += 1
		change_day_label(day_count)

	# Določanje trenutne faze
	var new_stage: Stages

	if elapsed_time < DAY_LENGTH:
		new_stage = Stages.DAY

	elif elapsed_time < DAY_LENGTH + TRANSITION_LENGTH:
		new_stage = Stages.DUSK

	elif elapsed_time < DAY_LENGTH + TRANSITION_LENGTH + NIGHT_LENGTH:
		new_stage = Stages.NIGHT

	else:
		new_stage = Stages.DAWN

	# Prehod izvedemo samo ob spremembi faze
	if new_stage != current_stage:
		current_stage = new_stage

		match current_stage:
			Stages.DAY:
				canvas_modulator.color = DAY_COLOR
				player_lamp.energy = 0.0

			Stages.DUSK:
				start_transition_to_night()

			Stages.NIGHT:
				canvas_modulator.color = NIGHT_COLOR
				player_lamp.energy = 3.0

			Stages.DAWN:
				start_transition_to_day()

	change_time_label(update_time(elapsed_time))


func update_time(time: float) -> String:
	var game_minutes: float = 0.0

	if time < DAY_LENGTH:
		# 06:00 -> 18:00 (12 ur)
		game_minutes = 360.0 + time * (720.0 / DAY_LENGTH)

	elif time < DAY_LENGTH + TRANSITION_LENGTH:
		# 18:00 -> 19:00 (1 ura)
		game_minutes = 1080.0 + (time - DAY_LENGTH) * (60.0 / TRANSITION_LENGTH)

	elif time < DAY_LENGTH + TRANSITION_LENGTH + NIGHT_LENGTH:
		# 19:00 -> 05:00 (10 ur)
		game_minutes = 1140.0 + (time - DAY_LENGTH - TRANSITION_LENGTH) * (600.0 / NIGHT_LENGTH)

	else:
		# 05:00 -> 06:00 (1 ura)
		game_minutes = 300.0 + (time - DAY_LENGTH - TRANSITION_LENGTH - NIGHT_LENGTH) * (60.0 / TRANSITION_LENGTH)

	game_minutes = fposmod(game_minutes, 1440.0)

	var hours: int = int(game_minutes) / 60
	var minutes: int = int(game_minutes) % 60

	return "%02d:%02d" % [hours, minutes]


func start_transition_to_night() -> void:
	if current_tween && current_tween.is_running():
		current_tween.kill()

	current_tween = create_tween()
	current_tween.set_parallel(true)

	current_tween.tween_property(
		canvas_modulator,
		"color",
		NIGHT_COLOR,
		TRANSITION_LENGTH
	)

	current_tween.tween_property(
		player_lamp,
		"energy",
		3.0,
		TRANSITION_LENGTH
	)


func start_transition_to_day() -> void:
	if current_tween && current_tween.is_running():
		current_tween.kill()

	current_tween = create_tween()
	current_tween.set_parallel(true)

	current_tween.tween_property(
		canvas_modulator,
		"color",
		DAY_COLOR,
		TRANSITION_LENGTH
	)

	current_tween.tween_property(
		player_lamp,
		"energy",
		0.0,
		TRANSITION_LENGTH
	)


func change_time_label(time: String) -> void:
	time_label.text = time


func change_day_label(day: int) -> void:
	day_label.text = "Day: " + str(day)
