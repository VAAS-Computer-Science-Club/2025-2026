shader_type sky;
render_mode use_half_res_pass;

// --- Uniforms ---
group_uniforms SkyColors;
uniform vec3 day_top_color : source_color = vec3(0.1, 0.4, 0.8);
uniform vec3 day_bottom_color : source_color = vec3(0.4, 0.7, 0.9);
uniform vec3 night_top_color : source_color = vec3(0.01, 0.01, 0.1);
uniform vec3 night_bottom_color : source_color = vec3(0.05, 0.05, 0.05);
uniform vec3 sun_color : source_color = vec3(1.0, 0.9, 0.7);
uniform vec3 moon_color : source_color = vec3(1.0, 1.0, 1.0);

group_uniforms SunMoon;
uniform float sun_size = 0.1;
uniform float moon_size = 0.05;
uniform float sun_bloom = 10.0;

group_uniforms Clouds;
uniform sampler2D cloud_noise : filter_linear_mipmap_anisotropic;
uniform vec4 cloud_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float cloud_speed = 0.01;
uniform float cloud_density = 0.5;

group_uniforms Stars;
uniform float star_intensity = 1.0;

// Helper: Rotation matrix for clouds
mat2 rot(float a) {
    float s = sin(a), c = cos(a);
    return mat2(vec2(c, -s), vec2(s, c));
}

void sky() {
    // 1. Basic Atmosphere Gradient based on Sun Angle
    float sun_angle = clamp(LIGHT0_DIRECTION.y, -1.0, 1.0);
    float day_night_blend = smoothstep(-0.2, 0.2, sun_angle);
    
    vec3 sky_color = mix(night_top_color, day_top_color, day_night_blend);
    vec3 horizon_color = mix(night_bottom_color, day_bottom_color, day_night_blend);
    
    vec3 col = mix(horizon_color, sky_color, clamp(EYEDIR.y, 0.0, 1.0));
    
    // 2. Sun
    float sun_dist = distance(EYEDIR, LIGHT0_DIRECTION);
    float sun = smoothstep(sun_size, sun_size * 0.9, sun_dist);
    col += sun * sun_color * sun_bloom * max(0.0, sun_angle);
    
    // 3. Moon (opposite to sun)
    vec3 moon_dir = -LIGHT0_DIRECTION;
    float moon_dist = distance(EYEDIR, moon_dir);
    float moon = smoothstep(moon_size, moon_size * 0.8, moon_dist);
    col += moon * moon_color * (1.0 - max(0.0, sun_angle));
    
    // 4. Stars (only at night)
    if (sun_angle < 0.2) {
        vec2 star_uv = EYEDIR.xy * 100.0;
        float stars = texture(cloud_noise, star_uv).r;
        stars = pow(stars, 20.0) * star_intensity * (1.0 - day_night_blend);
        col += stars;
    }
    
    // 5. Clouds (only on half_res pass for performance)
    if (AT_HALF_RES_PASS) {
        vec2 cloud_uv = EYEDIR.xz / abs(EYEDIR.y + 0.1);
        cloud_uv *= 0.5;
        cloud_uv += TIME * cloud_speed;
        
        float n = texture(cloud_noise, cloud_uv).r;
        n = smoothstep(1.0 - cloud_density, 1.0, n);
        
        // Color clouds based on sun angle (sunrise/sunset effect)
        vec3 final_cloud_color = mix(cloud_color.rgb * 0.3, cloud_color.rgb, day_night_blend);
        
        // Output to half-res
        COLOR = col;
    } else {
        // Blend clouds at full resolution
        col = mix(col, HALF_RES_COLOR.rgb, HALF_RES_COLOR.a);
        COLOR = col;
    }
}
