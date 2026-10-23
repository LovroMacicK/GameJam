class_name Crop extends Node2D

@export var crop_data: CropData
@onready var sprite: Sprite2D = $Sprite2D
@onready var growth_timer: Timer = $GrowthTimer

enum growth_stage { START, HALF_GROWN, READY_TO_HARVEST }
var current_stage = growth_stage.START


func _ready() -> void:
	sprite.texture = crop_data.growth_textures[0]

func _process(delta: float) -> void:
	update_growth_stage()

func update_growth_stage() -> void:
	if current_stage == growth_stage.READY_TO_HARVEST:
		return

	var third: float = crop_data.growth_time / 3.0

	if growth_timer.time_left > third * 2:
		current_stage = growth_stage.START

	elif growth_timer.time_left > 0:
		current_stage = growth_stage.HALF_GROWN

	update_texture(current_stage)

func update_texture(stage: growth_stage) -> void:
	if stage == growth_stage.START:
		sprite.texture = crop_data.growth_textures[0]
		
	elif stage == growth_stage.HALF_GROWN:
		sprite.texture = crop_data.growth_textures[1]
		
	elif stage == growth_stage.READY_TO_HARVEST:
		sprite.texture = crop_data.growth_textures[2]

func start_timer() -> void:
	growth_timer.start(crop_data.growth_time)

func _on_growth_timer_timeout() -> void:
	current_stage = growth_stage.READY_TO_HARVEST
	update_texture(current_stage)

func get_crop() -> ItemData:
	if current_stage == growth_stage.READY_TO_HARVEST:
		return crop_data.harvest_item
	
	return null
