shader_type spatial;
render_mode depth_prepass_alpha, cull_disabled, world_vertex_coords;

instance uniform vec4 tint : source_color = vec4(1.0);
uniform sampler2D albedo : filter_nearest_mipmap, repeat_enable;

uniform sampler2D wind_noise;
uniform float wind_strength = 0.1;
uniform float wind_speed = 0.05;

void vertex() {
	vec2 noise_uv = (VERTEX.xy * 0.2) + vec2(TIME * wind_speed, 0.0);
	float wind = texture(wind_noise, noise_uv).r * 2.0 - 1.0;
	float sway = 1.0 - UV.x;
	VERTEX += cos(NORMAL + TIME) * sway * wind * wind_strength;
}

void fragment() {
	vec4 colour = texture(albedo, UV);
	
	ALBEDO = mix(colour.rgb, colour.rgb * tint.rgb, tint.a);
	ALPHA = colour.a;
	
	METALLIC = 0.0;
	ROUGHNESS = 1.0;
}
