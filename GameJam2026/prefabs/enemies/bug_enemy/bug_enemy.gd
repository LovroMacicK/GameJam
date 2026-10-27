class_name BugEnemy extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $Flippable/AnimatedSprite2D
@onready var flippable: Node2D = $Flippable
@onready var attack_cooldown_timer: Timer = $AttackCooldown
@onready var health_bar: ProgressBar = $HealthBar
@onready var attack_area: Area2D = $Flippable/AttackArea

@export var player: CharacterBody2D
@export var speed: float = 100.0
@export var damage: int = 10
@export var health: int = 30
@export var knockback_strength: float = 280.0
@export var stop_distance: float = 35.0

var playerInRange: bool = false
var isAttacking: bool = false
var canAttack: bool = true
var isDead: bool = false
var knockback_velocity: Vector2 = Vector2.ZERO


func _ready() -> void:
	if player == null:
		player = get_tree().get_first_node_in_group("player") as Player

	health_bar.max_value = health
	health_bar.value = health
	health_bar.hide()


func _physics_process(delta: float) -> void:
	if isDead or player == null:
		return

	var direction: Vector2 = player.global_position - global_position
	var distance: float = direction.length()

	if distance > stop_distance && !isAttacking:
		velocity = direction.normalized() * speed
	else:
		velocity = Vector2.ZERO

	velocity += knockback_velocity
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 900.0 * delta)

	flip_spider(direction)
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
	var animation_name: String

	if isAttacking:
		animation_name = "attack"
	elif direction == Vector2.ZERO:
		animation_name = "idle"
	else:
		animation_name = "walk"

	if sprite.animation != animation_name:
		sprite.play(animation_name)


func take_damage(amount: int, attacker_position: Vector2) -> void:
	if isDead:
		return

	health -= amount
	health_bar.value = maxi(health, 0)
	health_bar.show()

	var direction: Vector2 = (global_position - attacker_position).normalized()
	knockback_velocity = direction * knockback_strength

	hit_flash()

	if health <= 0:
		die()


func hit_flash() -> void:
	sprite.modulate = Color(3, 3, 3)

	var tween := create_tween()
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.12)


func die() -> void:
	isDead = true
	isAttacking = false
	velocity = Vector2.ZERO

	$CollisionShape2D.set_deferred("disabled", true)
	attack_area.set_deferred("monitoring", false)

	if sprite.sprite_frames.has_animation("death"):
		sprite.play("death")
		await sprite.animation_finished

	queue_free()


func attack() -> void:
	if isAttacking && canAttack && !isDead && player != null:
		if attack_area.overlaps_body(player):
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
	if body is Player && !isDead:
		isAttacking = true


func _on_attack_area_body_exited(body: Node2D) -> void:
	if body is Player:
		isAttacking = false


func _on_attack_cooldown_timeout() -> void:
	canAttack = true


func _on_animated_sprite_2d_frame_changed() -> void:
	if sprite.animation == "attack" && sprite.frame == 2:
		attack()
