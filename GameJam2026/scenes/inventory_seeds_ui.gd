class_name InventorySeedsUI extends Control

@onready var pumpkin_count: Label = $PumpkinSeeds/TextureRect/Label
@onready var eggplant_count: Label = $EggplantSeeds/TextureRect/Label
@onready var corn_count: Label = $CornSeeds/TextureRect/Label

@export var inventory: Inventory

func _process(_delta: float) -> void:
	refresh_count()

func refresh_count() -> void:
	if inventory == null:
		return

	pumpkin_count.text = str(inventory.get_count("pumpkin"))
	eggplant_count.text = str(inventory.get_count("eggplant"))
	corn_count.text = str(inventory.get_count("corn"))
