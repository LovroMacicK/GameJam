class_name Inventory extends Node

signal inventory_changed

@export var inventory_size: int = 12

var slots: Array[InventorySlot] = []


func _ready() -> void:
	initialize_inventory()


func initialize_inventory() -> void:
	slots.clear()

	for i in range(inventory_size):
		var slot = InventorySlot.new()
		slots.append(slot)

	inventory_changed.emit()


func add_item(item: ItemData, amount: int = 1) -> bool:
	if item == null or amount <= 0:
		return false

	var available_space: int = 0

	# Preverimo prostor v inventoryju
	for slot in slots:
		if slot.is_empty():
			available_space += item.max_stack
		elif slot.item == item:
			available_space += maxi(
				item.max_stack - slot.quantity, 0
			)

	if available_space < amount:
		return false

	var remaining: int = amount

	# Najprej zapolnimo obstoječe stacke
	for slot in slots:
		if slot.item == item and slot.quantity < item.max_stack:
			var space: int = item.max_stack - slot.quantity
			var to_add: int = mini(space, remaining)

			slot.quantity += to_add
			remaining -= to_add

			if remaining == 0:
				inventory_changed.emit()
				return true

	# Nato zapolnimo prazne slote
	for slot in slots:
		if slot.is_empty():
			var to_add: int = mini(item.max_stack, remaining)

			slot.item = item
			slot.quantity = to_add
			remaining -= to_add

			if remaining == 0:
				inventory_changed.emit()
				return true

	return false


func remove_item(item: ItemData, amount: int = 1) -> bool:
	if item == null or amount <= 0:
		return false

	if not has_item(item, amount):
		return false

	var remaining: int = amount

	for slot in slots:
		if slot.item == item:
			var to_remove: int = mini(slot.quantity, remaining)

			slot.quantity -= to_remove
			remaining -= to_remove

			if slot.quantity <= 0:
				slot.clear()

			if remaining == 0:
				inventory_changed.emit()
				return true

	return false


func get_item_count(item: ItemData) -> int:
	if item == null:
		return 0

	var total: int = 0

	for slot in slots:
		if slot.item == item:
			total += slot.quantity

	return total


func has_item(item: ItemData, amount: int = 1) -> bool:
	if item == null or amount <= 0:
		return false

	return get_item_count(item) >= amount


func clear_inventory() -> void:
	for slot in slots:
		slot.clear()

	inventory_changed.emit()
