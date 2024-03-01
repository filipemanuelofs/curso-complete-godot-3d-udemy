extends Node3D
class_name HitscanWeapon

@export var fire_rate := 14.0
@export var recoil := 0.08
@export var weapon_mesh: Node3D
@export var weapon_damage := 15
@export var muzzle_flash: GPUParticles3D
@export var sparks: PackedScene
@export var is_automatic: bool
@export var ammo_handler: AmmoHandler
@export var ammo_type: AmmoHandler.AMMO_TYPE

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var weapon_position := weapon_mesh.position
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var crosshair: Control = %Crosshair

var lerp_speed := 10.0
@export var is_weapon_equipped := false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_automatic:
		if Input.is_action_pressed("fire"):
			if cooldown_timer.is_stopped():
				shoot()
	else:
		if Input.is_action_just_pressed("fire"):
			if cooldown_timer.is_stopped():
				shoot()
	
	weapon_mesh.position = weapon_mesh.position.lerp(weapon_position, delta * lerp_speed)
	
	if is_enemy_collider():
		crosshair.set_target_enemy(true)
	else:
		crosshair.set_target_enemy(false)

func shoot() -> void:
	if ammo_handler.has_ammo(ammo_type):
		ammo_handler.use_ammo(ammo_type)
		muzzle_flash.restart()
		cooldown_timer.start(1.0 / fire_rate)
		weapon_mesh.position.z += recoil
		
		var collider := ray_cast_3d.get_collider()
		
		if ray_cast_3d.is_colliding():
			var spark := sparks.instantiate()
			add_child(spark)
			spark.global_position = ray_cast_3d.get_collision_point()
			if is_enemy_collider():
				collider.health -= weapon_damage

func is_enemy_collider() -> bool:
	return ray_cast_3d.get_collider() is Enemy
