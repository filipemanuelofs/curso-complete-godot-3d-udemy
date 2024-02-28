extends Node3D
class_name AmmoHandler

@export var ammo_label: Label

enum ammo_type {
	BULLET,
	SMALL_BULLET
}

var storage := {
	ammo_type.BULLET: 10,
	ammo_type.SMALL_BULLET: 60
}

func has_ammo(type: ammo_type) -> bool:
	return storage[type] > 0

func use_ammo(type: ammo_type) -> void:
	if has_ammo(type):
		storage[type] -= 1
		update_ammo_label(type)

func update_ammo_label(type: ammo_type) -> void:
	ammo_label.text = str(storage[type])

func add_ammo(type: ammo_type, amount: int, update_label: bool) -> void:
	storage[type] += amount
	if update_label:
		update_ammo_label(type)
