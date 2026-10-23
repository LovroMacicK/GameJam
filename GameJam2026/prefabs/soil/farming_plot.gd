class_name FarmingPlot extends Area2D

@export var inventory: Inventory

@export var pumpkin_scene: PackedScene
@export var corn_scene: PackedScene
@export var eggplant_scene: PackedScene
@export var interaction_distance: float = 64.0

@onready var crop_container: Node2D = $CropContainer

var crop_type: String
var current_crop: Crop = null

func _ready() -> void:
	set_process_input(true)

func plant_crop(seed: String) -> bool:
	if current_crop != null or seed.is_empty() or not _is_player_close():
		return false

	if inventory == null or inventory.get_count(seed) <= 0:
		return false

	var crop_scene: PackedScene

	match seed:
		"pumpkin_seed":
			crop_scene = pumpkin_scene
		"corn_seed":
			crop_scene = corn_scene
		"eggplant_seed":
			crop_scene = eggplant_scene
		_:
			return false

	if crop_scene == null:
		return false

	current_crop = crop_scene.instantiate()
	crop_type = seed.trim_suffix("_seed")

	crop_container.add_child(current_crop)
	if not inventory.get_count(seed) > 0:
		current_crop.queue_free()
		current_crop = null
		crop_type = ""
		return false

	inventory.remove(seed, 1)
	return true


func harvest() -> bool:
	if current_crop == null or not _is_player_close():
		return false

	var crop_name: String = current_crop.get_crop()

	if crop_name == "":
		return false

	if inventory == null or inventory.get_count(crop_name) >= 64:
		return false

	inventory.add(crop_name, 1)

	current_crop.queue_free()
	current_crop = null
	crop_type = ""
	return true


func _is_player_close() -> bool:
	var player: Node2D = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		player = get_tree().current_scene.get_node_or_null("player") as Node2D

	if player == null:
		return false

	return global_position.distance_to(player.global_position) <= interaction_distance


func _on_input_event_pickable(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if inventory == null:
		return

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			plant_crop(inventory.get_selected_item())

		elif event.button_index == MOUSE_BUTTON_RIGHT:
			harvest()
