class_name Inventory extends Node

signal inventory_changed

var inventory: Dictionary = {
	"pumpkin_seed": 5, #0
	"corn_seed": 0, #1
	"eggplant_seed": 0, #2
	"pumpkin": 0, #3
	"corn": 0, #4
	"eggplant": 0 #5
}

var tools_inventory: Array[String] = [
	"scythe", #0
	"watering_can" #1
]

var selected_slot_tools_inventory: int = -1
var selected_slot_inventory: int = -1


func change_selected_slot_tools_inventory(item: String) -> void:
	var tool_index := tools_inventory.find(item)
	if tool_index == -1:
		return

	selected_slot_tools_inventory = tool_index

	selected_slot_inventory = -1


func change_selected_slot_inventory(item: String) -> void:
	var seed_items := ["pumpkin_seed", "corn_seed", "eggplant_seed"]
	var seed_index := seed_items.find(item)
	if seed_index == -1:
		return

	selected_slot_inventory = seed_index

	selected_slot_tools_inventory = -1


func get_selected_item() -> String:
	if selected_slot_tools_inventory != -1:
		return tools_inventory[selected_slot_tools_inventory]

	if selected_slot_inventory == 0:
		return "pumpkin_seed"
	elif selected_slot_inventory == 1:
		return "corn_seed"
	elif selected_slot_inventory == 2:
		return "eggplant_seed"

	return ""


func remove(item: String, amount: int) -> void:
	if amount <= 0 or not inventory.has(item) or inventory[item] < amount:
		return

	inventory[item] -= amount
	inventory_changed.emit()


func add(item: String, amount: int) -> void:
	if amount <= 0 or not inventory.has(item):
		return

	inventory[item] = mini(inventory[item] + amount, 64)
	inventory_changed.emit()


func get_count(item: String) -> int:
	return inventory.get(item, 0)
