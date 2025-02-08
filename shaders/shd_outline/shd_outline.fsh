//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float pixelW;
uniform float pixelH;
uniform vec3 color;

void main()
{
	vec2 offsetx;
	offsetx.x = pixelW;
	vec2 offsety;
	offsety.y = pixelH;
	
	bool outline = false;
	
	float alpha = texture2D(gm_BaseTexture, v_vTexcoord).a;
	
	if (alpha == 0.0)
	{
		alpha += ceil(texture2D(gm_BaseTexture, v_vTexcoord + offsetx).a);
		alpha += ceil(texture2D(gm_BaseTexture, v_vTexcoord - offsetx).a);
		alpha += ceil(texture2D(gm_BaseTexture, v_vTexcoord + offsety).a);
		alpha += ceil(texture2D(gm_BaseTexture, v_vTexcoord - offsety).a);
		
		outline = true;
	}
	
    gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	
	if (outline)
	{
		gl_FragColor.rgb = color;
		
		if (alpha != 0.0)
		{
			gl_FragColor.a = 0.75;
		}
	}
	
	if ( gl_FragColor.a < 0.05 ) { discard; }
}
