shader_type canvas_item;
uniform vec4 adder : source_color;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	if (COLOR.r <= 0.1) {
		COLOR.a = COLOR.r;
	} else {
		COLOR += adder;
	}
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
