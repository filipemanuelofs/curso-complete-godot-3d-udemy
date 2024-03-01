extends CharacterBody3D
class_name Player

const MOUSE_SENS := 0.006

@onready var camera_pivot: Node3D = $CameraPivot
@onready var damage_animation_player: AnimationPlayer = $DamageTexture/DamageAnimationPlayer
@onready var game_over_menu: Control = $GameOverMenu
@onready var ammo_handler: AmmoHandler = %AmmoHandler
@onready var weapon_handler: Node3D = %WeaponHandler

@onready var camera_3d: Camera3D = %Camera3D
@onready var camera_3d_fov := camera_3d.fov

@onready var weapon_camera_3d: Camera3D = %WeaponCamera3D
@onready var weapon_camera_3d_fov := weapon_camera_3d.fov
@onready var health_bar: ProgressBar = %HealthBar

@export var speed := 8.0
@export var jump_height := 1.0
@export var fall_multiplier := 2.0
@export var max_health := 100
@export var aim_multiplier := 0.7

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_motion := Vector2.ZERO
var health := max_health: get = get_health, set = set_health
var lerp_speed_in := 20.0
var lerp_speed_out := 20.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("aim"):
		camera_3d.fov = lerp(camera_3d.fov, camera_3d_fov * aim_multiplier, delta * lerp_speed_in)
		weapon_camera_3d.fov = lerp(
			weapon_camera_3d.fov, 
			weapon_camera_3d_fov * aim_multiplier, 
			delta * lerp_speed_in
		)
	else:
		camera_3d.fov = lerp(camera_3d.fov, camera_3d_fov, delta * lerp_speed_out)
		weapon_camera_3d.fov = lerp(
			weapon_camera_3d.fov, 
			weapon_camera_3d_fov, 
			delta * lerp_speed_out
		)

func _physics_process(delta: float) -> void:
	handle_camera()
	# Add the gravity.
	if not is_on_floor():
		if velocity.y >= 0:
			velocity.y -= gravity * delta
		else:
			velocity.y -= gravity * delta * fall_multiplier

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = sqrt(jump_height * 2.0 * gravity)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		if Input.is_action_pressed("aim"):
			velocity.x *= aim_multiplier 
			velocity.z *= aim_multiplier 
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		mouse_motion = -event.relative * MOUSE_SENS
		if event.is_action_pressed("aim"):
			mouse_motion *= aim_multiplier

	if event.is_action_pressed("quit"):
		get_tree().quit()

func handle_camera() -> void:
	rotate_y(mouse_motion.x)
	camera_pivot.rotate_x(mouse_motion.y)
	camera_pivot.rotation_degrees.x = clampf(camera_pivot.rotation_degrees.x, -90.0, 90.0)
	mouse_motion = Vector2.ZERO

# getters/setters
func get_health() -> int:
	return health

func set_health(value: int) -> void:
	if value < health:
		damage_animation_player.stop(false)
		damage_animation_player.play("take_damage")
	health = value
	set_health_bar(health)
	if health <= 0:
		game_over_menu.game_over()
		#get_tree().quit()

func get_current_weapon() -> HitscanWeapon:
	for child in weapon_handler.get_children():
		var weapon := child as HitscanWeapon
		if weapon.is_weapon_equipped:
			return weapon
	return null

func set_health_bar(_health: int) -> void:
	health_bar.value = health
	health_bar.modulate = Color.RED.lerp(Color.GREEN, (float(health) / float(max_health)))
