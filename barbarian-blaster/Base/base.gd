extends Node3D

@export var MAX_HEALTH: int = 5

@onready var label_3d: Label3D = $Label3D

var current_health: int: get = get_current_health, set = set_current_health


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_current_health(MAX_HEALTH)
	set_label(get_current_health())


func take_damage() -> void:
	set_current_health(get_current_health() - 1)
	set_label(get_current_health())
	
	label_3d.modulate = Color.RED.lerp(Color.WHITE, (float(get_current_health()) / float(MAX_HEALTH)))
	
	if get_current_health() < 1:
		get_tree().reload_current_scene()


func get_current_health() -> int:
	return current_health


func set_current_health(value: int) -> void:
	current_health = value


func set_label(value: int) -> void:
	label_3d.modulate = Color.WHITE
	label_3d.text = "{0}/{1}".format([value, MAX_HEALTH])
