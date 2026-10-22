class_name InventorySlotUI extends PanelContainer

@onready var item_icon: TextureRect = $TextureRect
@onready var quantity_label: Label = $Label


func update_slot(slot: InventorySlot) -> void:
	if slot == null || slot.is_empty():
		item_icon.texture = null
		quantity_label.text = ""

	item_icon.texture = slot.item.icon

	if slot.quantity > 1:
		quantity_label.text = str(slot.quantity)
	else:
		quantity_label.text = ""
