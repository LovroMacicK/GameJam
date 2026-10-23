class_name FarmingPlot extends Area2D

@export var crop_scene: PackedScene
@export var inventory: Inventory

@onready var crop_container: Node2D = $CropContainer

var current_crop: Crop


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("right_click"):
		$crop.get_crop()

func plant_crop(seed: ItemData) -> bool:
	if current_crop != null:
		return false
	
	if seed == null || seed.item_type != ItemData.ItemType.SEED:
		return false
	
	if !inventory.has_item(seed, 1):
		return false
	
	var crop: Crop =  crop_scene.instantiate()
	
	crop.crop_data = seed.crop_data
	crop.start_timer()
	
	current_crop = crop
	inventory.remove_item(seed, 1)
	
	return true
	

func harvest() -> bool:
	
	if current_crop == null:
		return false
	
	var item: ItemData = current_crop.get_crop()
	
	if item == null:
		return false
	
	var amount: int = current_crop.crop_data.harvest_amount
	
	if !inventory.add_item(item, amount):
		return false
	
	current_crop.queue_free()
	current_crop = null
	
	return true
	
