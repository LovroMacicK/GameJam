class_name SpiderEnemy extends CharacterBody2D

@export var player: CharacterBody2D

@export var speed: float
@export var damage: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_pos: Vector2 = player.global_position
	var direction_x: float = move_toward(global_position.x, player_pos.x, delta)
	var direction_y: float = move_toward(global_position.y, player_pos.y, delta)
	velocity = Vector2(direction_x, direction_y)
	move_and_slide()
