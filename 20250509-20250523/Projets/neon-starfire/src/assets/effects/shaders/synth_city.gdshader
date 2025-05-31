shader_type canvas_item;

uniform float time;
uniform vec2 resolution;

float sd_skyscraper(vec2 p, float w, float h) {
    vec2 k1 = vec2(0.0, h);
    vec2 k2 = vec2(-w, h);
    p.x = abs(p.x);
    vec2 ca = p - vec2(0.0, h);
    vec2 cb = p - k1 + k2;
    float s = (cb.x < 0.0 && ca.y < 0.0) ? -1.0 : 1.0;
    return s * (dot(ca, ca));
}

float sun(vec2 uv, float battery) {
    float val = smoothstep(0.7, 0.69, length(uv));
    float bloom = smoothstep(0.7, 0.0, length(uv));
    float cut = 5.0 * sin((uv.y + time * 0.1 * (1.02)) * 60.0)
        + clamp(uv.y * 15.0, -6.0, 6.0);
    cut = clamp(cut, 0.0, 1.0);
    return clamp(val * cut, 0.0, 1.0) + bloom * 0.6;
}

float grid(vec2 uv, float battery) {
    vec2 size = vec2(uv.y, uv.y * uv.y * 0.2) * 0.01;
    uv += vec2(0.0, time * 1.0 * (battery + 0.05));
    uv = abs(fract(uv) - 0.5);
    vec2 lines = smoothstep(size, vec2(0.0), uv);
    lines += smoothstep(size * 5.0, vec2(0.0), uv) * 0.4 * battery;
    return clamp(lines.x + lines.y, 0.0, 3.0);
}

void fragment() {
    vec2 uv = (2.0 * FRAGCOORD.xy - resolution.xy) / resolution.y;
    float battery = 1.0;

    float fog = smoothstep(0.2, -0.05, abs(uv.y + 0.2));
    vec3 col = vec3(0.0, 0.1, 0.2);

    if (uv.y < -0.2) {
        uv.y = 3.0 / (abs(uv.y + 0.2) + 0.05);
        uv.x *= uv.y * 1.0;
        float grid_val = grid(uv, battery);
        col = mix(col, vec3(1.0, 0.25, 0.5), grid_val);
    } else {
        uv.y -= 0.34;
        col = vec3(1.0, 0.4, 0.4);
        float sun_val = sun(uv, battery);
        col = mix(col, vec3(1.0, 0.85, 0.3), uv.y * 2.5 + 0.2);
        col = mix(vec3(0.0, 0.0, 0.0), col, sun_val);
        col += vec3(0.1 + 1.25 * (1.0 - smoothstep(-0.2, 0.8, (0.2 + uv.y))),
                    0.15 * (1.0 - smoothstep(-0.2, 0.8, (0.2 + uv.y))),
                    0.7 - 0.45 * (smoothstep(-0.2, 0.8, (0.2 + uv.y))));

        uv.y -= 0.2;
        float bldg_d = max(-uv.y * 1.2 + 0.18, 0.0);
        float bldg_val = sd_skyscraper(uv + vec2(0.1 * mod(0.0 + time, 40.0) - 2.0, 0.5), 0.1, 0.15);
        col = mix(col, mix(vec3(0.0, 0.0, 0.25), vec3(1.0, 0.0, 0.5), bldg_d), step(bldg_val, 0.0));
        // Ajoutez d'autres bâtiments ici si nécessaire
    }

    col += fog * fog * fog;
    col = mix(vec3(0.75, 0.1, 0.45) * 0.2, col, battery * 0.7);

    COLOR = vec4(col, 1.0);
}
