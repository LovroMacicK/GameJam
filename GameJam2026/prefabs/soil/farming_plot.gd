class_name FarmingPlot extends Area2D

@export var inventory: Inventory

@export var pumpkin_scene: PackedScene
@export var corn_scene: PackedScene
@export var eggplant_scene: PackedScene

@onready var crop_container: Node2D = $CropContainer

var crop_type: String
var current_crop: Crop = null

func _ready() -> void:
	print("Process mode: ", process_mode)
	print("Input enabled: ", is_processing_input())
	set_process_input(true)

func plant_crop(seed: String) -> void:
	if current_crop != null:
		return

	if inventory.get_count(seed) <= 0:
		return

	var crop_scene: PackedScene

	match seed:
		"pumpkin_seed":
			crop_scene = pumpkin_scene
		"corn_seed":
			crop_scene = corn_scene
		"eggplant_seed":
			crop_scene = eggplant_scene
		_:
			return

	current_crop = crop_scene.instantiate()
	crop_type = seed.trim_suffix("_seed")

	crop_container.add_child(current_crop)
	inventory.remove(seed, 1)


func harvest() -> void:
	if current_crop == null:
		return

	var crop_name: String = current_crop.get_crop()

	if crop_name == "":
		return

	if inventory.get_count(crop_name) >= 64:
		return

	inventory.add(crop_name, 1)

	current_crop.queue_free()
	current_crop = null
	crop_type = ""

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		print("KLIK ZAZNAN")

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	print("Klik na FarmingPlot!")
	if event is InputEventMouseButton and event.pressed:
		print("Miška deluje!")
		if event.button_index == MOUSE_BUTTON_LEFT:
			plant_crop(inventory.get_selected_item())

		elif event.button_index == MOUSE_BUTTON_RIGHT:
			harvest()
