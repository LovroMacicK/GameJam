class_name Main extends Node2D

@onready var inventory_ui: Control = $player/CanvasLayer/InventoryUI
@export var pumpkin_seed: ItemData
@onready var inventory: Inventory = $Inventory


func _ready() -> void:
	print(inventory.add_item(pumpkin_seed, 5))
	print(inventory.get_item_count(pumpkin_seed))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_inventory"):
		if inventory_ui.visible:
			inventory_ui.visible = false
		else:
			inventory_ui.visible = true
