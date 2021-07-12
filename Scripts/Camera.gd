extends SpringArm


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var mouse_movement = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	# Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func _input(event):
	if event is InputEventMouseMotion:
		mouse_movement += event.relative

func _unhandled_input(event):
	if Input.is_action_pressed("zoom_in"):
		spring_length -= 4
		if spring_length <= 8:
			spring_length = 8
	
	if Input.is_action_pressed("zoom_out"):
		spring_length += 4
		if spring_length >= 64:
			spring_length = 64

func _physics_process(delta):
	if Input.is_action_pressed("drag"):
		if mouse_movement != Vector2():
			rotation_degrees.y -= mouse_movement.x
			rotation_degrees.x -= mouse_movement.y
			if rotation_degrees.x <= -90:
				rotation_degrees.x = -90
			if rotation_degrees.x >= 0:
				rotation_degrees.x = 0
			mouse_movement = Vector2()
	else:
		mouse_movement = Vector2()
