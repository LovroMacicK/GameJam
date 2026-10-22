class_name Main extends Node2D

@onready var inventory_ui: Control = %InventoryUI

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_inventory"):
		if inventory_ui.visible:
			inventory_ui.visible = false
		else:
			inventory_ui.visible = true
