class_name Inventory extends Control

@export var inventory: Inventory
@export var slot_scene: PackedScene

@onready var grid: GridContainer = $PanelContainer/MarginContainer/VBoxContainer/GridContainer


func _ready() -> void:
	if inventory == null || slot_scene == null:
		push_error("InventoryUI: Inventory ali Slot Scene ni nastavljen!")

	inventory.inventory_changed.connect(refresh_inventory)

	create_slots()
	refresh_inventory()


func create_slots() -> void:
	for slot in inventory.slots:
		var slot_ui: InventorySlotUI = slot_scene.instantiate()
		grid.add_child(slot_ui)


func refresh_inventory() -> void:
	for i in range(inventory.slots.size()):
		var slot_ui: InventorySlotUI = grid.get_child(i)
		slot_ui.update_slot(inventory.slots[i])
