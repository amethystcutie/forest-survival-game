shader_type spatial;

//render_mode unshaded;

uniform sampler2D noise_tex;
uniform vec3 base_colour : source_color;
uniform vec3 top_colour : source_color;
instance uniform float level;
uniform float height = 1.0;
uniform float grass_frequency = 1.0;
uniform float wind_strength = 1.0;

void vertex() {;
	VERTEX.y += height * level;
}

void fragment() {
	vec3 grass_colour = mix(base_colour, top_colour, level);
	
	float value = texture(noise_tex, UV * grass_frequency).r;
	
	value = texture(noise_tex, UV * grass_frequency + 0.01 * (sin(TIME) * wind_strength * level)).r;
	ALBEDO = grass_colour;
	ALPHA = float(value > level);
	
}
