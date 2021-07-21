extends MeshInstance

onready var m = get_active_material(0) # Referencia al material actual.

# Parámetros actuales del shader:
var albedo = Quat(0.01, 0.03, 0.05, 1.0)
var metallic = 0.0
var roughness = 0.1
var fresnel_factor = 0.1

var WaveA = Quat(1.0, 1.0, 0.25, 20.0) # Parámetros ola A
var WaveB = Quat(1.0, 0.0, 0.5, 50.0) # Parámetros ola B

var time_factor = 0.1

func _physics_process(_delta): # Función que se ejecuta cada 1/60 segundos.
	var fix_time  = OS.get_ticks_msec() # Tiempo actual del programa
	
	# Se asigna el tiempo actual al shader para sincronizarlo con el tiempo de
	# las físicas:
	m.set_shader_param("outside_time", fix_time)
	

# Señales recibidas cuando se cambian los parámetros en la GUI:
func _on_RBox_value_changed(value):
	albedo.x = value
	m.set_shader_param("albedo", albedo)

func _on_GBox_value_changed(value):
	albedo.y = value
	m.set_shader_param("albedo", albedo)

func _on_BBox_value_changed(value):
	albedo.z = value
	m.set_shader_param("albedo", albedo)

func _on_MetalBox_value_changed(value):
	metallic = value
	m.set_shader_param("metallic", metallic)

func _on_RoughBox_value_changed(value):
	roughness = value
	m.set_shader_param("roughness", roughness)

func _on_FresnelBox_value_changed(value):
	fresnel_factor = value
	m.set_shader_param("fresnel_factor", fresnel_factor)

func _on_DirXA_value_changed(value):
	WaveA.x = value
	m.set_shader_param("WaveA", WaveA)

func _on_DirYA_value_changed(value):
	WaveA.y = value
	m.set_shader_param("WaveA", WaveA)

func _on_SteepnessA_value_changed(value):
	WaveA.z = value
	m.set_shader_param("WaveA", WaveA)

func _on_WavelengthA_value_changed(value):
	WaveA.w = value
	m.set_shader_param("WaveA", WaveA)

func _on_DirXB_value_changed(value):
	WaveB.x = value
	m.set_shader_param("WaveB", WaveB)

func _on_DirYB_value_changed(value):
	WaveB.y = value
	m.set_shader_param("WaveB", WaveB)

func _on_SteepnessB_value_changed(value):
	WaveB.z = value
	m.set_shader_param("WaveB", WaveB)

func _on_WavelengthB_value_changed(value):
	WaveB.w = value
	m.set_shader_param("WaveB", WaveB)

func _on_TimeFBox_value_changed(value):
	time_factor = value
	m.set_shader_param("time_factor", time_factor)
