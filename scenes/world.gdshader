shader_type canvas_item;

uniform bool wind = true;
uniform float wind_multiplier = 0.2;
uniform float increase = 5;
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}
void vertex() {
	float random_value = 0.0;
	if (wind) {
		random_value = rand(vec2(TIME,TIME)) * wind_multiplier;
	}
	if (VERTEX.y > VERTEX.x){
		if (VERTEX.x > 1.0) {
			VERTEX += vec2(-sin(TIME) * (5.0+increase),-cos(TIME) * 5.0);
		} else {
			VERTEX += vec2(cos(TIME) * (10.0+increase),cos(TIME) * 10.0);
		}

	} else {
		if (VERTEX.y > 0.1) {
			VERTEX += vec2(cos(TIME + random_value) * (10.0+increase),-sin(TIME) * 10.0);
		} else{
			VERTEX += vec2(cos(TIME + random_value) * (10.0+increase),sin(TIME) * 10.0);
		}
	}

	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
