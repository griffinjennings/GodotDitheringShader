shader_type canvas_item;
render_mode unshaded;

uniform sampler2D dither_pattern;
uniform bool enabled = true;
uniform bool greyscale = false;
uniform float dither_amount = 1.0;
uniform int colours = 4;

float dither(float raw, float dither, int depth) {
	
	float div = 1.0 / float(depth);
	float val = 0.0;
	
	for (int i = 0; i < depth; i++) {
		if (raw <= div * (float(i + 1))) {
			if ((raw * float(depth)) - float(i) <= dither * 0.999) {
				val = div * float(i);
			} else {
				val = div * float(i + 1);
			}
			break;
		}
	}

	return val;
}

void fragment() {
	vec4 raw = texture(TEXTURE, UV);
	vec3 dither_pixel = texture(dither_pattern, UV).rgb;
	if (enabled == true) {
		
		if (greyscale == true) {
			raw.rgb = vec3((raw.r + raw.g + raw.b) / 3.0);
		}
		
		COLOR.r = dither(raw.r, (dither_pixel.x - 0.5) * dither_amount + 0.5, colours - 1);
		COLOR.g  = dither(raw.g, (dither_pixel.x - 0.5) * dither_amount + 0.5, colours - 1);
		COLOR.b = dither(raw.b, (dither_pixel.x - 0.5) * dither_amount + 0.5, colours - 1);
		
	} else {
		COLOR.rgb = raw.rgb;
	}
	COLOR.a = raw.a;

}
