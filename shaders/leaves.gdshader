shader_type spatial;
render_mode alpha_to_coverage_and_one,
depth_draw_opaque,
specular_disabled;

instance uniform vec4 tint : source_color = vec4(1.0);
uniform sampler2D albedo : filter_nearest_mipmap;

uniform sampler2D wind_noise;
uniform float wind_strength = 0.1;
uniform float wind_speed = 0.05;

void vertex() {
	vec2 noise_uv = (VERTEX.xy * 0.2) + vec2(TIME * wind_speed, 0.0);
	float wind = texture(wind_noise, noise_uv).r * 2.0 - 1.0;
	float sway = 1.0 - UV.x;
	VERTEX += cos(NORMAL + TIME) * sway * wind * wind_strength;

	NORMAL = normalize(VERTEX - vec3(0.0, 10.0, 0.0));
}

void fragment() {
	vec4 colour = texture(albedo, UV * 2.0);
	
	ALBEDO = mix(colour.rgb, colour.rgb * tint.rgb, tint.a);
	ALPHA = colour.a;
	
	SPECULAR = 0.0;
	ROUGHNESS = 1.0;
}
