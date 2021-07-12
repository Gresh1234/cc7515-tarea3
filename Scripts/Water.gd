extends MeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var m = get_active_material(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var fix_time  = OS.get_ticks_msec()
	m.set_shader_param("outside_time", fix_time)
