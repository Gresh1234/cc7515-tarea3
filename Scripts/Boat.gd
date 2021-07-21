extends RigidBody

export var WaveA = Quat(1.0, 1.0, 0.25, 20.0) # Parámetros ola A
export var WaveB = Quat(1.0, 0.0, 0.5, 50.0) # Parámetros ola B
export var buoyancy = 10.0; # Constante de flotabilidad

# Referencias a los 4 puntos flotadores
onready var fl = $FloatyFL
onready var fr = $FloatyFR
onready var rl = $FloatyRL
onready var rr = $FloatyRR

# Función que calcula el y (aproximado) de las olas del shader.
func getWaveHeight(wave : Quat, p : Vector3, time : float):
	var k = 2.0 * PI / wave.w
	var c = sqrt(9.8 / k)
	var d = Vector2(wave.x, wave.y).normalized()
	var f = k * (d.dot(Vector2(p.x, p.z)) - c * time/1000)
	var a = wave.z / k
	
	return a * sin(f)

# Función que se ejecuta cada 1/60 seegundos.
func _physics_process(_delta):
	var time  = OS.get_ticks_msec() # Se obtiene el tiempo del programa
	
	# Se normalizan los empinamientos de las olas como en el shader.
	var steepness = Vector2(WaveA.z, WaveB.z).length()
	WaveA.z = WaveA.z / max(1.0, steepness)
	WaveB.z = WaveB.z / max(1.0, steepness)
	
	# Se calcula la altura para cada uno de los 4 puntos flotadores.
	var waterlineFL = getWaveHeight(WaveA, fl.global_transform.origin, time) + getWaveHeight(WaveB, fl.global_transform.origin, time)
	var waterlineFR = getWaveHeight(WaveA, fr.global_transform.origin, time) + getWaveHeight(WaveB, fr.global_transform.origin, time)
	var waterlineRL = getWaveHeight(WaveA, rl.global_transform.origin, time) + getWaveHeight(WaveB, rl.global_transform.origin, time)
	var waterlineRR = getWaveHeight(WaveA, rr.global_transform.origin, time) + getWaveHeight(WaveB, rr.global_transform.origin, time)
	
	# Se aplica una fuerza a cada uno de los 4 puntos flotadores según su
	# posición con respecto al agua.
	if fl.global_transform.origin.y < waterlineFL:
		add_force(Vector3.UP * buoyancy * clamp(waterlineFL - fl.global_transform.origin.y, 0, 1), fl.translation)
	if fr.global_transform.origin.y < waterlineFR:
		add_force(Vector3.UP * buoyancy * clamp(waterlineFR - fr.global_transform.origin.y, 0, 1), fr.translation)
	if rl.global_transform.origin.y < waterlineRL:
		add_force(Vector3.UP * buoyancy * clamp(waterlineRL - rl.global_transform.origin.y, 0, 1), rl.translation)
	if rr.global_transform.origin.y < waterlineRR:
		add_force(Vector3.UP * buoyancy * clamp(waterlineRR - rr.global_transform.origin.y, 0, 1), rr.translation)

# Señales recibidas cuando se cambian los parámetros en la GUI:
func _on_DirXA_value_changed(value):
	WaveA.x = value

func _on_DirYA_value_changed(value):
	WaveA.y = value

func _on_SteepnessA_value_changed(value):
	WaveA.z = value

func _on_WavelengthA_value_changed(value):
	WaveA.w = value

func _on_DirXB_value_changed(value):
	WaveB.x = value

func _on_DirYB_value_changed(value):
	WaveB.y = value

func _on_SteepnessB_value_changed(value):
	WaveB.z = value

func _on_WavelengthB_value_changed(value):
	WaveB.w = value
