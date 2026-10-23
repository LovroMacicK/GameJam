class_name InventorySeedsUI extends Control

@onready var pumpkin_seeds: Label = $PumpkinSeeds/TextureRect/Label
@onready var eggplant_seeds: Label = $EggplantSeeds/TextureRect/Label
@onready var corn_seeds: Label = $CornSeeds/TextureRect/Label

@export var inventory: Inventory

func _process(delta: float) -> void:
	refresh_count()

func refresh_count() -> void:
	pumpkin_seeds.text = str(inventory.get_count("pumpkin"))
	eggplant_seeds.text = str(inventory.get_count("eggplant"))
	corn_seeds.text = str(inventory.get_count("corn"))
