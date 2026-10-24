class_name InventoryUI extends Control

@export var inventory: Inventory

@onready var slot_2_label: Label = %QuantityLabel_Slot_2
@onready var slot_3_label: Label = %QuantityLabel_Slot_3
@onready var slot_4_label: Label = %QuantityLabel_Slot_4

@onready var grids: Array[PanelContainer] = [%Slot_0, %Slot_1, %Slot_2, %Slot_3, %Slot_4]

var current_slot: int = 0
var item_in_use: String = ""
var seeds_in_use: String = ""


func _ready() -> void:
	if inventory == null:
		push_error("InventoryUI potrebuje povezavo do Inventory.")
		return

	inventory.inventory_changed.connect(update_count)
	inventory.change_selected_slot_tools_inventory("scythe")
	update_count()
	update_selected_ui()


func update_selected_ui() -> void:
	for i in range(grids.size()):
		if i == current_slot:
			var style := StyleBoxFlat.new()
			style.bg_color = Color.RED
			grids[i].add_theme_stylebox_override("panel", style)
		else:
			grids[i].remove_theme_stylebox_override("panel")


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_1:
				current_slot = 0
				inventory.change_selected_slot_tools_inventory("scythe")
			KEY_2:
				current_slot = 1
				inventory.change_selected_slot_tools_inventory("watering_can")
			KEY_3:
				current_slot = 2
				inventory.change_selected_slot_inventory("corn_seed")
			KEY_4:
				current_slot = 3
				inventory.change_selected_slot_inventory("eggplant_seed")
			KEY_5:
				current_slot = 4
				inventory.change_selected_slot_inventory("pumpkin_seed")
			_:
				return

		update_selected_ui()


func update_count() -> void:
	if inventory == null:
		return

	slot_2_label.text = str(inventory.get_count("corn_seed"))
	slot_3_label.text = str(inventory.get_count("eggplant_seed"))
	slot_4_label.text = str(inventory.get_count("pumpkin_seed"))
