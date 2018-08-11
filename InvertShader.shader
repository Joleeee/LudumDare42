shader_type canvas_item;

uniform bool inverted = false;
uniform vec4 black : hint_color;
uniform vec4 white : hint_color;

void fragment()
{
	vec4 col = texture(TEXTURE, UV);
	if(inverted && col.a > 0.0)
	{
		vec4 wdif = abs(col - white);
		vec4 bdif = abs(col - black);
		if(max(max(wdif.r, wdif.g), wdif.b) < 0.1)
		{
			col = black;
		}
		if(max(max(bdif.r, bdif.g), bdif.b) < 0.1)
		{
			col = white;
		}
	}
	COLOR = col;
}