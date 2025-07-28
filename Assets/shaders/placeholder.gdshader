shader_type spatial;

void fragment() {
	ALBEDO=vec2(float(int(UV.x*8.)+int(UV.y*8.)&1),0).xyx;
}