class_name CropData extends Resource

@export var crop_name: String
@export var growth_time: float = 30.0

@export var growth_textures: Array[Texture2D]

@export var harvest_item: ItemData
@export_range(1, 99) var harvest_amount: int = 1
