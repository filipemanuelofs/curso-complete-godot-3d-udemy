extends Node3D
class_name AmmoHandler

@export var ammo_label: Label

enum AMMO_TYPE {
	BULLET,
	SMALL_BULLET
}

var storage := {
	AMMO_TYPE.BULLET: 10,
	AMMO_TYPE.SMALL_BULLET: 60
}

func has_ammo(_ammo_type: AMMO_TYPE) -> bool:
	return storage[_ammo_type] > 0

func use_ammo(_ammo_type: AMMO_TYPE) -> void:
	if has_ammo(_ammo_type):
		storage[_ammo_type] -= 1
		update_ammo_label(_ammo_type)

func update_ammo_label(_ammo_type: AMMO_TYPE) -> void:
	ammo_label.text = str(storage[_ammo_type])

func add_ammo(_ammo_type: AMMO_TYPE, _amount: int, _update_label: bool) -> void:
	storage[_ammo_type] += _amount
	if _update_label:
		update_ammo_label(_ammo_type)
