extends Node2D

@onready var world: World = %World
@export var enemies: Array[PackedScene]

@onready var spawn_points: Array[Node] = get_children().filter(
	func(node: Node) -> bool: return node is Node2D
)


func get_random_spawn_point() -> Vector2:
	var random: int = randi_range(0, spawn_points.size() - 1)
	return spawn_points[random].global_position


func _on_spawn_timer_timeout() -> void:
	if world.current_stage != World.Stages.DUSK && world.current_stage != World.Stages.NIGHT:
		return

	if enemies.is_empty() or spawn_points.is_empty():
		return
	
	var random_enemy: PackedScene = enemies.pick_random()
	var enemy: Node2D = random_enemy.instantiate()
	if enemy is SpiderEnemy:
		enemy.player = get_tree().get_first_node_in_group("player")
	
	get_tree().current_scene.add_child(enemy)
	enemy.global_position = get_random_spawn_point()
