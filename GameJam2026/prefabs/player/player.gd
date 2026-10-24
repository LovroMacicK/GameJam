extends CharacterBody2D
class_name Player

const SPEED: float = 200.0
const RUNNING_SPEED: float = 320.0

@onready var sprite: AnimatedSprite2D = $Sprite

@export var inventory: Inventory

var previous_state: String = "walk_front"


func _physics_process(_delta: float) -> void:
	move()


func move() -> void:
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")

	if Input.is_action_pressed("shift"):
		velocity = direction.normalized() * RUNNING_SPEED
	else:
		velocity = direction.normalized() * SPEED
	flip(direction)
	animation_state_machine(direction)
	move_and_slide()


func flip(direction: Vector2) -> void:
	if direction.x > 0:
		sprite.flip_h = true
	elif direction.x < 0:
		sprite.flip_h = false


func animation_state_machine(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		if Input.is_action_pressed("shift"):
			sprite.speed_scale = 1.8
		else:
			sprite.speed_scale = 1

	if direction == Vector2.ZERO:
		_play_animation("idle")
	else:
		_play_animation("walk_front")


func _play_animation(animation_name: String) -> void:
	if sprite.sprite_frames == null:
		return

	if sprite.sprite_frames.has_animation(animation_name):
		sprite.play(animation_name)
	elif sprite.sprite_frames.has_animation("idle"):
		sprite.play("idle")
