shader_type spatial;
render_mode cull_disabled, unshaded;

uniform sampler2D dither_pattern;

float value_check(float raw, float dither) {
	if (raw < dither * 0.025) {return 0.0;}
	else if (raw < dither * 0.05) {return 0.025;}
	else if (raw < dither * 0.1) {return 0.05;}
	else if (raw < dither * 0.2) {return 0.1;}
	else if (raw < dither * 0.3) {return 0.2;}
	else if (raw < dither * 0.4) {return 0.3;}
	else if (raw < dither * 0.5) {return 0.4;}
	else if (raw < dither * 0.8) {return 0.5;}
	else if (raw < dither) {return 0.8;}
	else {return 1.0;}
}


void vertex() {

	 POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
	vec3 raw = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb; 
	vec3 dither_pixel = (textureLod(dither_pattern, SCREEN_UV, 0.0).rgb) / 5.0 + 0.7;
	
	
	ALBEDO.r = value_check(raw.r, dither_pixel.x);
	ALBEDO.g = value_check(raw.g, dither_pixel.x);
	ALBEDO.b = value_check(raw.b, dither_pixel.x);
	
//	if (SCREEN_UV.x < 0.5) {
//		ALBEDO = raw
//	}
}
