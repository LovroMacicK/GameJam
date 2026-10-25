extends StaticBody2D

@onready var shop_ui: Control = %ShopUI

@export var player: Player
@export var inventory: Inventory

var playerNear: bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shop_ui.visible = false
	playerNear = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") && playerNear:
		shop_ui.visible = !shop_ui.visible


func _on_shop_body_entered(body: Node2D) -> void:
	if body is Player:
		playerNear = true


func _on_shop_body_exited(body: Node2D) -> void:
	if body is Player:
		playerNear = false
		shop_ui.visible = false
