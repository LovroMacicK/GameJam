class_name Crop extends Node2D

@export var crop_name: String
@export var growth_time: float = 30.0
@export var growth_textures: Array[Texture2D]
@export var growth_offsets_y: Array[int]

@onready var sprite: Sprite2D = $Sprite2D
@onready var growth_timer: Timer = $GrowthTimer

enum growth_stage {
	START,
	HALF_GROWN,
	READY_TO_HARVEST,
}
var current_stage = growth_stage.START


func _ready() -> void:
	if growth_textures.size() < 3:
		return

	sprite.texture = growth_textures[0]
	sprite.position.y = growth_offsets_y[0]
	growth_timer.one_shot = true
	growth_timer.start(growth_time)


func _process(_delta: float) -> void:
	if current_stage == growth_stage.READY_TO_HARVEST:
		return

	if growth_timer.time_left <= growth_time / 2.0:
		current_stage = growth_stage.HALF_GROWN
		sprite.texture = growth_textures[1]
		sprite.position.y = growth_offsets_y[1]


func _on_growth_timer_timeout() -> void:
	current_stage = growth_stage.READY_TO_HARVEST
	sprite.texture = growth_textures[2]
	sprite.position.y = growth_offsets_y[2]


func get_crop() -> String:
	if current_stage == growth_stage.READY_TO_HARVEST:
		return crop_name

	return ""
