extends MarginContainer


@export var start_gold: int = 150
@onready var label: Label = $Label

var gold: int: get = get_gold, set = set_gold

func _ready() -> void:
	set_gold(start_gold)
	set_label(start_gold)
	
func _process(delta: float) -> void:
	set_label(get_gold())

func get_gold() -> int:
	return gold

func set_gold(value: int) -> void:
	gold = max(value, 0)

func set_label(value: int) -> void:
	label.text = "GOLD: {0}".format([value])
