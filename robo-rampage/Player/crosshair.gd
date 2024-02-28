extends Control


func _draw() -> void:
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
