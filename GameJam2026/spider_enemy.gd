class_name SpiderEnemy extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $Flippable/AnimatedSprite2D
@onready var flippable: Node2D = $Flippable
@onready var attack_cooldown_timer: Timer = $AttackCooldown

@export var player: CharacterBody2D
@export var speed: float
@export var damage: int

var playerInRange: bool
var isAttacking: bool
var canAttack: bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerInRange = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if !isAttacking:
		var direction: Vector2 = (player.global_position - global_position).normalized()
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO

	flip_spider(velocity)
	animation_state_machine(velocity)
	move_and_slide()


func flip_spider(direction: Vector2) -> void:
	if direction.x > 0:
		flippable.scale.x = -1.0
		flippable.position.x = 32
	elif direction.x < 0:
		flippable.scale.x = 1.0
		flippable.position.x = 0


func animation_state_machine(direction: Vector2) -> void:
	if isAttacking:
		sprite.play("attack")
	elif direction == Vector2.ZERO:
		sprite.play("idle")
	else:
		sprite.play("walk")


func attack() -> void:
	if isAttacking && canAttack:
		player.take_damage(damage)
		canAttack = false
		attack_cooldown_timer.start()


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is Player:
		playerInRange = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body is Player:
		playerInRange = false


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body is Player:
		isAttacking = true


func _on_attack_area_body_exited(body: Node2D) -> void:
	if body is Player:
		isAttacking = false


func _on_attack_cooldown_timeout() -> void:
	canAttack = true
