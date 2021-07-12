extends RigidBody

export var WaveA = Quat(1.0, 1.0, 0.25, 20.0);
export var WaveB = Quat(1.0, 0.0, 0.5, 50.0);
export var buoyancy = 10.0;

onready var fl = $FloatyFL
onready var fr = $FloatyFR
onready var rl = $FloatyRL
onready var rr = $FloatyRR

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func getWaveHeight(wave : Quat, p : Vector3, time : float):
	var k = 2.0 * PI / wave.w
	var c = sqrt(9.8 / k)
	var d = Vector2(wave.x, wave.y).normalized()
	var f = k * (d.dot(Vector2(p.x, p.z)) - c * time/1000)
	var a = wave.z / k
	
	var xp = d.x * (a * cos(f))
	var zp = d.y * (a * cos(f))
	
	var fp = k * (d.dot(Vector2(xp, zp)) - c * time/1000)
	
	return a * sin(f)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var time  = OS.get_ticks_msec()
	
	var waterlineFL = getWaveHeight(WaveA, fl.global_transform.origin, time) + getWaveHeight(WaveB, fl.global_transform.origin, time)
	var waterlineFR = getWaveHeight(WaveA, fr.global_transform.origin, time) + getWaveHeight(WaveB, fr.global_transform.origin, time)
	var waterlineRL = getWaveHeight(WaveA, rl.global_transform.origin, time) + getWaveHeight(WaveB, rl.global_transform.origin, time)
	var waterlineRR = getWaveHeight(WaveA, rr.global_transform.origin, time) + getWaveHeight(WaveB, rr.global_transform.origin, time)
	
	
	if fl.global_transform.origin.y < waterlineFL:
		add_force(Vector3.UP * buoyancy * clamp(waterlineFL - fl.global_transform.origin.y, 0, 1), fl.translation)
	if fr.global_transform.origin.y < waterlineFR:
		add_force(Vector3.UP * buoyancy * clamp(waterlineFR - fr.global_transform.origin.y, 0, 1), fr.translation)
	if rl.global_transform.origin.y < waterlineRL:
		add_force(Vector3.UP * buoyancy * clamp(waterlineRL - rl.global_transform.origin.y, 0, 1), rl.translation)
	if rr.global_transform.origin.y < waterlineRR:
		add_force(Vector3.UP * buoyancy * clamp(waterlineRR - rr.global_transform.origin.y, 0, 1), rr.translation)
