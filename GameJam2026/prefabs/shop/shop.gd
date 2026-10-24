extends StaticBody2D

@onready var shop_ui: Control = %ShopUI

var playerNear: bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shop_ui.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if shop_ui.visible == true:
			shop_ui.visible = false
		elif shop_ui.visible == false:
			shop_ui.visible = true


func _on_shop_body_entered(body: Node2D) -> void:
	if body is Player:
		playerNear = true


func _on_shop_body_exited(body: Node2D) -> void:
	if body is Player:
		playerNear = false
		shop_ui.visible = false
