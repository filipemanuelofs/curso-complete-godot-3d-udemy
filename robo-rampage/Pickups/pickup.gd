extends Area3D

@export var is_health := false
@export var amount: int = 20
@export var ammo_type: AmmoHandler.AMMO_TYPE

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("idle")

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		var player := body as Player
		if not is_health:
			player.ammo_handler.add_ammo(
				ammo_type, 
				amount, 
				player.get_current_weapon().ammo_type == ammo_type)
		else:
			player.health += amount
		queue_free()
