class_name InventorySlot extends RefCounted

var item: ItemData = null
var quantity: int = 0


func is_empty() -> bool:
	if item == null or quantity <= 0:
		return true
	else:
		return false


func clear() -> void:
	item = null
	quantity = 0
