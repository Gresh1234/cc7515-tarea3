extends SpringArm

# Vector inicial de movimiento de la cámara
var mouse_movement = Vector2()

# Función de entrada
func _input(event):
	# Cuando el mouse se mueve, se agrega el desplazamiento al vector
	if event is InputEventMouseMotion:
		mouse_movement += event.relative

# Función de entrada sin manejar
func _unhandled_input(event):
	# Cuando se mueve la rueda hacia arriba, se acerca la cámara
	if Input.is_action_pressed("zoom_in"):
		spring_length -= 4
		if spring_length <= 8:
			spring_length = 8
	
	# Cuando se mueve la rueda hacia abajo, se aleja la cámara
	if Input.is_action_pressed("zoom_out"):
		spring_length += 4
		if spring_length >= 64:
			spring_length = 64

# Función que se ejecuta cada 1/60 segundo
func _physics_process(delta):
	# Cuando el click izquierdo está presionado, se aplica el movimiento
	if Input.is_action_pressed("drag"):
		if mouse_movement != Vector2():
			rotation_degrees.y -= mouse_movement.x
			rotation_degrees.x -= mouse_movement.y
			if rotation_degrees.x <= -90:
				rotation_degrees.x = -90
			if rotation_degrees.x >= 0:
				rotation_degrees.x = 0
			mouse_movement = Vector2()
	# De lo contrario, se ignora.
	else:
		mouse_movement = Vector2()
