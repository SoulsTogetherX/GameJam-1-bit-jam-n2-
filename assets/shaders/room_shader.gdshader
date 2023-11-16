shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment(){
	vec4 baseColor = vec4(texture(SCREEN_TEXTURE, SCREEN_UV).rgb, 0.5);
	COLOR = baseColor * (0.8 * abs(cos(TIME * 0.2)) + 0.1);
}