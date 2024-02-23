extends PathFollow3D


@export var SPEED: float = 10.0
@export var ENEMY_VALUE: int = 15

@export var max_health: int = 50

@onready var base: Node = get_tree().get_first_node_in_group("Base")
@onready var bank: Node = get_tree().get_first_node_in_group("Bank")

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var DAMAGE_AREA: float = 1.0
var current_health: int: get = get_current_health, set = set_current_health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_current_health(max_health)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress += delta * SPEED
	
	if progress_ratio == DAMAGE_AREA:
		base.take_damage()
		queue_free()
		#set_process(false) or queue_free()
	
	if get_current_health() < 1:
		queue_free()
		bank.gold += ENEMY_VALUE


func get_current_health() -> int:
	return current_health


func set_current_health(value: int) -> void:
	if value < current_health:
		animation_player.play("take_damage")
	current_health = value
