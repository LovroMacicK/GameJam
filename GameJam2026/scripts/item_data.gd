class_name ItemData extends Resource

enum ItemType { SEED, CROP }

@export var id: String
@export var item_name: String
@export var item_type: ItemType
@export var icon: Texture2D
@export_range(1, 64) var max_stack: int = 64

@export_group("Farming")
@export var crop_data: CropData
