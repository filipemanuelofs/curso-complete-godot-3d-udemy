extends Node


signal stop_spawning_enemies

@onready var timer: Timer = $Timer
@export var game_lenght: float = 30.0
@export var spawn_time_curve: Curve
@export var enemy_health_curve: Curve

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start(game_lenght)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_progress_ratio() -> float:
	return 1.0 - (timer.time_left / game_lenght)


func get_spawn_time() -> float:
	return spawn_time_curve.sample(game_progress_ratio())


func get_enemy_health() -> float:
	return enemy_health_curve.sample(game_progress_ratio())


func _on_timer_timeout() -> void:
	stop_spawning_enemies.emit()
