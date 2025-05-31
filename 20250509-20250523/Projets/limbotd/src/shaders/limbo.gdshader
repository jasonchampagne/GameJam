shader_type canvas_item;

uniform sampler2D noise1;
uniform sampler2D noise2;


uniform vec4 back_color : hint_color;
uniform vec4 color1 : hint_color;
uniform vec4 color2 : hint_color;

uniform vec2 scroll1 = vec2(0.02, 0);
uniform vec2 scroll2 = vec2(-0.05, 0.09);
uniform float wave_scroll = 0.1;


void fragment(){
	vec4 depth1 = texture(noise1, UV + scroll1 * TIME);
	
	vec4 color = mix(color1, back_color, depth1.r);
	
	vec4 wave_col = mix(color1, back_color, depth1.r);
	
	
	
	
	vec4 depth2 = texture(noise2, UV + scroll2 * TIME);
	vec4 fore_color = color2 * depth2;
	color = mix(color, fore_color, depth2 + depth2 / 10.);
	
	float wave = sin(UV.x + wave_scroll * TIME);
	color = mix(color, wave_col - wave_col / 2. , wave);
	
	
	COLOR = color;
	
}