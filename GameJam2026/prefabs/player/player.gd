extends CharacterBody2D
class_name Player

const SPEED: float = 200.0
const RUNNING_SPEED: float = 320.0

@onready var sprite: AnimatedSprite2D = %Sprite
@onready var attack_area: Area2D = %Hitbox
@onready var flippable: Node2D = %Flippable
@onready var health_bar: ProgressBar = %HealthBar

@export var attack_damage: int = 10
@export var inventory: Inventory
@export var health: int
@export var world: World
@export var game_over_ui: Control

var isAlive: bool
var isAttacking: bool
var movement_lock: bool = false

#Name: Level: Price:
var multiplier_dictionary: Dictionary = {
	"damage": {
		"level": 0,
		"max_level": 5,
		"multiplier": 0.25,
		"prices": [60, 120, 200, 300, 450]
	},
	"health": {
		"level": 0,
		"max_level": 5,
		"multiplier": 0.20,
		"prices": [50, 100, 175, 275, 400]
	}
}
var damage_multiplier: float = 1.0
var health_multiplier: float = 1.0
var lamp_multiplier: float = 1.0
var speed_multiplier: float = 1.0

var previous_state: String = "walk_front"


func _ready() -> void:
	health_bar.max_value = health
	health_bar.value = health
	isAlive = true


func _physics_process(_delta: float) -> void:
	if isAlive:
		move()
		heal()

		if Input.is_action_just_pressed("left_click"):
			var selected_item: String = inventory.get_selected_item()

			match selected_item:
				"scythe":
					attack()
				"watering_can":
					water()


func move() -> void:
	if movement_lock || (sprite.animation == "watering" && isAttacking):
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	velocity = direction.normalized() * SPEED * speed_multiplier

	flip(direction)
	animation_state_machine(direction)
	move_and_slide()


func flip(direction: Vector2) -> void:
	if direction.x > 0 && !isAttacking:
		flippable.scale.x = -1.0
	elif direction.x < 0 && !isAttacking:
		flippable.scale.x = 1.0


func animation_state_machine(direction: Vector2) -> void:
	if isAttacking:
		return

	if direction != Vector2.ZERO:
		_play_animation("walk_front")
	else:
		_play_animation("idle")


func _play_animation(animation_name: String) -> void:
	if sprite.sprite_frames == null:
		return

	if sprite.sprite_frames.has_animation(animation_name):
		sprite.play(animation_name)
	elif sprite.sprite_frames.has_animation("idle"):
		sprite.play("idle")


func attack() -> void:
	if isAttacking:
		return

	isAttacking = true
	movement_lock = true
	velocity = Vector2.ZERO
	sprite.speed_scale = 1.0
	_play_animation("attack")

	await get_tree().create_timer(0.25).timeout
	movement_lock = false


func water() -> void:
	if isAttacking:
		return

	isAttacking = true
	velocity = Vector2.ZERO
	sprite.speed_scale = 1.0
	_play_animation("watering")


func take_damage(damage: int) -> void:
	if !isAlive:
		return

	health = maxi(health - damage, 0)
	health_bar.value = health

	if health <= 0:
		isAlive = false
		velocity = Vector2.ZERO

		if game_over_ui != null:
			game_over_ui.show()
			game_over_ui.process_mode = Node.PROCESS_MODE_ALWAYS

		get_tree().paused = true


func heal() -> void:
	if !isAlive:
		return

	if world.current_stage == World.Stages.DAY && health < health_bar.max_value:
		health = mini(health + 5, int(health_bar.max_value))
		health_bar.value = health

func apply_upgrade(upgrade_name: String) -> void:
	var upgrade: Dictionary = multiplier_dictionary[upgrade_name]
	var multiplier: float = 1.0 + upgrade["level"] * upgrade["multiplier"]

	match upgrade_name:
		"speed":
			speed_multiplier = multiplier

		"damage":
			damage_multiplier = multiplier
			
		"health":
			var old_max_health: int = int(health_bar.max_value)
			var new_max_health: int = int(100 * multiplier)
			health = mini(health + new_max_health - old_max_health, new_max_health)
			health_bar.max_value = new_max_health
			health_bar.value = health
			health_multiplier = multiplier

		"lamp":
			lamp_multiplier = multiplier
			#TODO


func _on_sprite_animation_finished() -> void:
	if sprite.animation == "attack" or sprite.animation == "watering":
		isAttacking = false


func _on_sprite_frame_changed() -> void:
	if sprite.animation == "attack" && sprite.frame == 1:
		for body in attack_area.get_overlapping_bodies():
			if body is SpiderEnemy or body is BugEnemy:
				body.take_damage(int(attack_damage * damage_multiplier), global_position)
