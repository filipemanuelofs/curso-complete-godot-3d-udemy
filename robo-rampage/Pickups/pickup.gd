extends Area3D


@export var ammo_type: AmmoHandler.AMMO_TYPE
@export var amount: int = 20

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("idle")

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		var player := body as Player
		player.ammo_handler.add_ammo(
			ammo_type, 
			amount, 
			player.get_current_weapon().ammo_type == ammo_type)
		queue_free()
