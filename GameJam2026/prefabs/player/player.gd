extends CharacterBody2D
class_name Player

const SPEED: float = 10000.0
const RUNNING_SPEED: float = 16000.0

var hasSeeds: bool = true

@onready var sprite: AnimatedSprite2D = $Sprite

var previous_state: String = "walk_front"


func _physics_process(delta: float) -> void:
	move(delta)

func move(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	if Input.is_action_pressed("shift"):
		velocity = direction.normalized() * RUNNING_SPEED * delta
	else:
		velocity = direction.normalized() * SPEED * delta
	flip(direction)
	#animation_state_machine(direction)
	move_and_slide()

func flip(direction: Vector2) -> void:
	if direction.x > 0:
		sprite.flip_h = false
	elif direction.x < 0:
		sprite.flip_h = true

func animation_state_machine(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		
		if Input.is_action_pressed("shift"):
			sprite.speed_scale = 1.8
		else:
			sprite.speed_scale = 1
		
		if direction.y > 0:
			sprite.play("walk_front")
			previous_state = "walk_front"

		elif direction.y < 0:
			sprite.play("walk_back")
			previous_state = "walk_back"
		
		elif direction.y == 0 && direction.x != 0:
			sprite.play("walk_side")
		
		else:
			sprite.play(previous_state)

	else:
		if previous_state == "walk_front":
			sprite.play("idle_front")

		elif previous_state == "walk_back":
			sprite.play("idle_back")
