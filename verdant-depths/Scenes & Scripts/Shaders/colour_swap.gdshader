shader_type canvas_item;

uniform vec4 from_colors : source_color;
uniform vec4 to_colors : source_color;

uniform vec4 from_colors_1 : source_color;
uniform vec4 to_colors_1 : source_color;

uniform vec4 from_colors_2 : source_color;
uniform vec4 to_colors_2 : source_color;

uniform vec4 from_colors_3 : source_color;
uniform vec4 to_colors_3 : source_color;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);

	if (distance(tex_color.rgb, from_colors.rgb) < 0.01) {
		tex_color.rgb = to_colors.rgb;
	}
	else if (distance(tex_color.rgb, from_colors_1.rgb) < 0.01) {
		tex_color.rgb = to_colors_1.rgb;
	}
	else if (distance(tex_color.rgb, from_colors_2.rgb) < 0.01) {
		tex_color.rgb = to_colors_2.rgb;
	}
	else if (distance(tex_color.rgb, from_colors_3.rgb) < 0.01) {
		tex_color.rgb = to_colors_3.rgb;
	}

	COLOR = tex_color;
}
