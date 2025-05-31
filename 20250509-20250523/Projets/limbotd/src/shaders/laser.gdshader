shader_type canvas_item;

uniform sampler2D color_ramp;
uniform float scroll_speed = -1.;
uniform sampler2D noise;
uniform vec4 noise_color : hint_color;

void fragment(){
	vec4 color = texture(color_ramp, vec2(fract(UV.x + scroll_speed * TIME), UV.y));
	float alpha = texture(noise, vec2(UV.x - TIME, UV.y)).r * 2.;
	
	color = mix(color, noise_color, 1. - alpha);
	
	COLOR = color;
}