shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	float alpha = texture(TEXTURE, UV).a;
	vec3 colour = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;
	colour = vec3(1.0) - colour;
	COLOR = vec4(colour, alpha);
}
