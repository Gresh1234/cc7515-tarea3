shader_type spatial; // Se declara el tipo de shader

// Se declara pi como constante
const float PI = 3.141592;

// Se declaran algunas propiedades y variables internas:
render_mode diffuse_burley, specular_schlick_ggx, cull_back, depth_draw_alpha_prepass;
// Tiempo exterior al shader para sincronizarlo con las físicas
uniform float outside_time;
varying vec3 world_position;
varying vec2 tex_position;
varying vec4 WaveAN;
varying vec4 WaveBN;
varying float outside_timeN;

// Parámetros de aspecto del agua:
uniform vec4 albedo : hint_color = vec4(0.01, 0.03, 0.05, 1.0);
uniform float metallic : hint_range(0,1) = 0.0;
uniform float roughness : hint_range(0,1) = 0.1;
uniform float fresnel_factor : hint_range(0,1) = 0.1;
uniform sampler2D normalmap;

// Parámetros de oleaje: (Dirección x, Dirección en y, Empinamiento, Longitud de Onda)
uniform vec4 WaveA = vec4(1.0, 1.0, 0.25, 20.0);
uniform vec4 WaveB = vec4(1.0, 0.0, 0.5, 50.0);

// Parámetro de oleaje pequeño para el normal map:
uniform float time_factor : hint_range(0,1) = 0.1;

// Función para el vertex shader que simula una ola trocoidal:
vec3 GerstnerWave(vec4 wave, vec3 p, inout vec3 tangent, inout vec3 binormal, float time) {
	float k = 2.0 * PI / wave.w; // Número de olas basado en la longitud de ola.
	float c = sqrt(9.8 / k); // Velocidad de fase de las olas basado en k y g.
	vec2 d = normalize(wave.xy); // Dirección normalizada de la ola.
	float f = k * (dot(d, p.xz) - c * time); // Función temporal de la ola.
	float a = wave.z / k; // Amplitud de las olas basada en k.
	
	tangent += vec3( // Vector tangente para el vértice.
		-d.x * d.x * (wave.z * sin(f)),
		d.x * (wave.z * cos(f)),
		-d.x * d.y * (wave.z * sin(f))
	);
	binormal += vec3( // Vector binormal para el vértice.
		-d.x * d.y * (wave.z * sin(f)),
		d.y * (wave.z * cos(f)),
		-d.y * d.y * (wave.z * sin(f))
	);
	
	return vec3( // Vector de desplazamiento para el vértice.
		d.x * (a * cos(f)),
		a * sin(f),
		d.y * (a * cos(f))
	);
}

// Vertex shader:
void vertex() {
	// Posición global c/r al mundo para alinearlo con las físicas
	world_position = (WORLD_MATRIX * vec4(VERTEX, 1.0)).xyz;
	tex_position = world_position.xz;
	
	// Se pasa el tiempo externo de milisegundos a segundos
	outside_timeN = outside_time/1000.0;
	
	// Se normalizan los empinamientos de las olas combinadas para evitar loops
	WaveAN = WaveA;
	WaveBN = WaveB;
	float steepness = sqrt(pow(WaveA.z, 2) + pow(WaveB.z, 2));
	WaveAN.z = WaveA.z / max(1.0, steepness);
	WaveBN.z = WaveB.z / max(1.0, steepness);
	
	// Se calcula el desplazamiento ambas olas para el vértice
	vec3 gridPoint = world_position.xyz;
	vec3 tangent = vec3(1, 0, 0);
	vec3 binormal = vec3(0, 0, 1);
	vec3 p = gridPoint;
	p += GerstnerWave(WaveAN, gridPoint, tangent, binormal, outside_timeN);
	p += GerstnerWave(WaveBN, gridPoint, tangent, binormal, outside_timeN);
	
	// Se calcula el vector normal como un producto cruz entre tangente y binormal
	vec3 normal = normalize(cross(binormal, tangent));
	
	// Se aplica el desplazamiento al vértice y se asigna su normal
	VERTEX.xyz = p;
	NORMAL = normal;
}

void fragment() {
	// Efecto fresnel para que el agua se vea más reflectante
	float fresnel = sqrt(1.0 - dot(NORMAL, VIEW));
	
	// Parámetros del material, donde al albedo se le agrega el efecto fresnel
	METALLIC = metallic;
	ROUGHNESS = roughness;
	ALBEDO = albedo.rgb + (fresnel_factor * fresnel);
	
	// Se genera una textura para el normal map a partir de la superposición de
	// los desplazamientos y escalas de ambas olas, con la textura de ruido
	// provista en el material
	vec3 normalmape = texture(normalmap, tex_position * max(0.01, WaveAN.z) - outside_timeN * WaveA.xy * time_factor).xyz + 
	texture(normalmap, tex_position * max(0.01, WaveBN.z) - outside_timeN * WaveB.xy * time_factor).xyz;
	NORMALMAP = normalize(normalmape);
}