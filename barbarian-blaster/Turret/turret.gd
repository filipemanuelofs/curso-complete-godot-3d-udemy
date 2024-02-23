extends Node3D

var TURRET_RANGE: float = 10.0

var enemy_path: Path3D
var target: PathFollow3D

@export var projectile: PackedScene

@onready var turret_top: Node3D = $TurretBase/TurretTop
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cannon: Node3D = $TurretBase/TurretTop/Cannon
@onready var turret_base: Node3D = $TurretBase

# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:
	target = get_best_target()
	if target:
		turret_base.look_at(target.global_position, Vector3.UP, true)


func _on_timer_timeout() -> void:
	if target:
		var shot = projectile.instantiate()
		add_child(shot)
		shot.global_position = cannon.global_position
		shot.direction = turret_base.global_transform.basis.z
		animation_player.play("fire")


func get_best_target() -> PathFollow3D:
	var best_target = null
	var best_progress = 0
	for enemy in enemy_path.get_children():
		if enemy is PathFollow3D:
			if enemy.progress > best_progress:
				var distance = global_position.distance_to(enemy.global_position)
				if distance < TURRET_RANGE:
					best_target = enemy
					best_progress = enemy.progress
	return best_target
