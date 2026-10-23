class_name InventorySlotUI extends PanelContainer

@onready var item_icon: TextureRect = $ItemIcon

var current_slot: int

signal slot_changed(slot: InventorySlot)

func _ready() -> void:
	current_slot = 0

func _process(delta: float) -> void:
	pass
	
