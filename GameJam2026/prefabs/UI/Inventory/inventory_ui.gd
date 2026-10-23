class_name InventoryUI
extends Control

@export var inventory: Inventory

@onready var grid: GridContainer = $PanelContainer/MarginContainer/VBoxContainer/GridContainer


func _ready() -> void:
	if !inventory.is_node_ready():
		await inventory.ready
		
	for i in range(inventory.slots.size()):
		var slot_ui: InventorySlotUI = grid.get_child(i)

		slot_ui.inventory_slot = inventory.slots[i]
		slot_ui.update_slot(inventory.slots[i])

		slot_ui.slot_changed.connect(refresh_slot)

	inventory.inventory_changed.connect(refresh_inventory)
	refresh_inventory()


func refresh_slot(slot: InventorySlot) -> void:
	
	for slot_ui: InventorySlotUI in grid.get_children():
		if slot_ui.inventory_slot == slot:
			slot_ui.update_slot(slot)
			return


func refresh_inventory() -> void:
	for i in range(inventory.slots.size()):
		var slot_ui: InventorySlotUI = grid.get_child(i)

		slot_ui.inventory_slot = inventory.slots[i]
		slot_ui.update_slot(slot_ui.inventory_slot)
