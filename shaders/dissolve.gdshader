shader_type spatial;

uniform float amount = 0;

void fragment() {
	ALPHA = amount;
}
