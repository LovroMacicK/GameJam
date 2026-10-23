class_name InventorySlotUI extends PanelContainer

@onready var item_icon: TextureRect = $ItemIcon
@onready var quantity_label: Label = $QuantityLabel

var inventory_slot: InventorySlot

signal slot_changed(slot: InventorySlot)

func update_slot(slot: InventorySlot) -> void:
	if slot == null || slot.is_empty():
		item_icon.texture = null
		quantity_label.text = "0"
		return

	item_icon.texture = slot.item.icon
	quantity_label.text = str(slot.quantity)

func _get_drag_data(at_position: Vector2) -> Variant:
	
	if inventory_slot == null || inventory_slot.is_empty():
		return null
	
	var preview: TextureRect = TextureRect.new()
	preview.texture = item_icon.texture
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.custom_minimum_size = Vector2(48, 48)
	
	set_drag_preview(preview)
	
	return inventory_slot

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is InventorySlot

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var source_slot: InventorySlot = data
	
	if source_slot == inventory_slot:
		return
	
	var old_item = inventory_slot.item
	var old_quantity = inventory_slot.quantity
	
	inventory_slot.item = source_slot.item
	inventory_slot.quantity = source_slot.quantity
	
	source_slot.item = old_item
	source_slot.quantity = old_quantity
	
	update_slot(inventory_slot)
	slot_changed.emit(source_slot)
