extends CharacterBody3D
class_name Enemy

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]

@export var attack_range := 1.5
@export var max_health := 180

const SPEED = 4.5

var player: Player
var provoked := false
var follow_range := 12.0
var health := max_health: get = get_health, set = set_health


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


func _process(_delta: float) -> void:
	if provoked:
		navigation_agent_3d.target_position = player.global_position


func _physics_process(delta: float) -> void:	
	var next_position := navigation_agent_3d.get_next_path_position()

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	var distance := global_position.distance_to(player.global_position)
	if distance <= follow_range:
		provoked = true
		if distance <= attack_range:
			playback.travel("Attack")
	else:
		provoked = false
	
	var direction := global_position.direction_to(next_position)
	if direction:
		look_at_target(direction)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func look_at_target(direction: Vector3) -> void:
	var adjusted_direction := Vector3(direction.x, 0, direction.z)
	look_at(global_position + adjusted_direction, Vector3.UP, true)

func attack() -> void:
	player.health -= 20

func get_health() -> int:
	return health

func set_health(value: int) -> void:
	health = value
	if health <= 0:
		queue_free()
	provoked = true
