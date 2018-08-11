shader_type canvas_item;
render_mode unshaded;

uniform float bleeding_range_x = 3.0;
uniform float bleeding_range_y = 2.0;
uniform float screen_width = 640.0;
uniform float screen_height = 360.0;
uniform float barrel_power : hint_range(1.0, 2.0) = 1.1;

uniform float lines_distance = 2.0;
uniform float lines_on_screen = 64;
uniform float scanline_alpha = 0.9;
uniform float lines_velocity = 0.0;

vec2 distort(vec2 p)
{
    float theta  = atan(p.y, p.x);
    float radius = length(p);
    radius = pow(radius, barrel_power);
    p.x = radius * cos(theta);
    p.y = radius * sin(theta);
    return 0.5 * (p + 1.0);
}

vec4 line(vec2 cord, float time, vec4 color)
{
	float line_row = floor((cord.y * lines_on_screen) + mod(time*lines_velocity, lines_distance));

	float n = 1.0 - ceil((mod(line_row,lines_distance)/lines_distance));

	vec4 c = color;
	c -= n*c*(1.0 - scanline_alpha);
	c.a = 1.0;
	return c;
}

void fragment()
{
	//BARREL
	vec2 uv = (SCREEN_UV - vec2(0.5)) * 1.04 + vec2(0.5);
	vec2 xy = 2.0 * uv - 1.0;
	
	float d = length(xy);
	if (d < 10.0)
	{
		xy = distort(xy);
	}else
	{
		xy = vec2(0, 0);
	}
	vec4 color = texture(SCREEN_TEXTURE, xy);
	
	//BLEED
	float pixel_width = 1.0/screen_width*bleeding_range_x;
	float pixel_height = 1.0/screen_height*bleeding_range_y;
	color = color*vec4(1, 0.6, 0.20, 1);
	vec4 color_left = texture(SCREEN_TEXTURE, distort((uv * 2.0 - 1.0) - vec2(pixel_width, pixel_height))); //distort makes the bleedings in world cords (aka it curves) instead of sreenspace
	color_left = color_left * vec4(0.25, 0.6, 1, 1);
	color = color + color_left;
	
	color = line(xy, TIME, color);
	
	//ANTI ALIASING
	float margin = 0.0015; //How much of the border to anit-alias
	//the comming variables reflect if we are going to anti-alias that side or those sides
	bool left = xy.x < 0.0 && xy.x > 0.0 - margin;
	bool right = xy.x > 1.0 && xy.x < 1.0 + margin;
	bool up = xy.y < 0.0 && xy.y > 0.0 - margin;
	bool down = xy.y > 1.0 && xy.y < 1.0 + margin;
	bool left_or_right = xy.y > 0.0 && xy.y < 1.0 && (left || right);
	bool up_or_down = xy.x > 0.0 && xy.x < 1.0 && (up || down);
	if(left_or_right)
	{
		float u = 1.0;
		if(left)
		{
			u = 1.0-xy.x/-margin;
		}
		else
		{
			u = 1.0-(1.0-xy.x)/-margin;
		}
		
		color *= vec4(u, u, u, 1.0);
	}
	else if(up_or_down)
	{
		float u = 1.0;
		if(up)
		{
			u = 1.0-xy.y/-margin;
		}
		else
		{
			u = 1.0-(1.0-xy.y)/-margin;
		}
		
		color *= vec4(u, u, u, 1.0);
	}
	//BORDER
	else if (xy.x < 0.0 || xy.x > 1.0 || xy.y < 0.0 || xy.y > 1.0)
	{
		color.rgb = vec3(0.0);
	}
	
	//APPLY
	COLOR = color;
}

//Made by Jole
