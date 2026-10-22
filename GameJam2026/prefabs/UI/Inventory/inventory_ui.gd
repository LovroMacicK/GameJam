class_name InventoryUI extends Control

@export var inventory_slots: Array[InventorySlotUI]
@onready var grid: GridContainer = $PanelContainer/MarginContainer/VBoxContainer/GridContainer

var current_slot_index: int

func refresh_slot(slot: InventorySlot) -> void:
	for slot_ui in inventory_slots:
		if slot_ui.inventory_slot == slot:
			slot_ui.update_slot(slot)
			break

func _ready() -> void:
		for slot_ui: InventorySlotUI in grid.get_children():
			slot_ui.slot_changed.connect(refresh_slot)
