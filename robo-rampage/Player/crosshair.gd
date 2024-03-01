extends Control

var _is_target_enemy := false: get = is_target_enemy, set = set_target_enemy

func _draw() -> void:
	if _is_target_enemy:
		draw_red_crosshair()
	else:
		draw_green_crosshair()

func draw_green_crosshair() -> void:
	# Ponto central, mira
	draw_circle(Vector2.ZERO, 3, Color.BLACK)
	draw_circle(Vector2.ZERO, 2, Color.GREEN)

	# Linhas 
	draw_line(Vector2(7, 0), Vector2(17, 0), Color.BLACK, 3) # Sombra
	draw_line(Vector2(8, 0), Vector2(16, 0), Color.GREEN, 1)
	
	draw_line(Vector2(-7, 0), Vector2(-17, 0), Color.BLACK, 3) # Sombra
	draw_line(Vector2(-8, 0), Vector2(-16, 0), Color.GREEN, 1)
	
	draw_line(Vector2(0, 7), Vector2(0, 17), Color.BLACK, 3) # Sombra
	draw_line(Vector2(0, 8), Vector2(0, 16), Color.GREEN, 1)
	
	draw_line(Vector2(0, -7), Vector2(0, -17), Color.BLACK, 3) # Sombra
	draw_line(Vector2(0, -8), Vector2(0, -16), Color.GREEN, 1)

func draw_red_crosshair() -> void:
	# Ponto central, mira
	draw_circle(Vector2.ZERO, 3, Color.BLACK)
	draw_circle(Vector2.ZERO, 2, Color.ORANGE_RED)

	# Linhas 
	draw_line(Vector2(7, 0), Vector2(17, 0), Color.BLACK, 3) # Sombra
	draw_line(Vector2(8, 0), Vector2(16, 0), Color.ORANGE_RED, 1)
	
	draw_line(Vector2(-7, 0), Vector2(-17, 0), Color.BLACK, 3) # Sombra
	draw_line(Vector2(-8, 0), Vector2(-16, 0), Color.ORANGE_RED, 1)
	
	draw_line(Vector2(0, 7), Vector2(0, 17), Color.BLACK, 3) # Sombra
	draw_line(Vector2(0, 8), Vector2(0, 16), Color.ORANGE_RED, 1)
	
	draw_line(Vector2(0, -7), Vector2(0, -17), Color.BLACK, 3) # Sombra
	draw_line(Vector2(0, -8), Vector2(0, -16), Color.ORANGE_RED, 1)


func is_target_enemy() -> bool:
	return _is_target_enemy

func set_target_enemy(value: bool) -> void:
	_is_target_enemy = value
	queue_redraw()
