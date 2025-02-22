varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 size;
uniform float thick;
uniform vec3 color;
uniform vec4 uvs;

const float rad_circle = 6.28319;

void main()
{
	float accuracy = 32.0;
	float tol = 0.0;

	vec4 baseColor = texture2D( gm_BaseTexture, v_vTexcoord );	
	float outline = 0.0;
	
	for (float i = 1.0; i <= thick; i++)
	{
		for(float d = 0.0; d < rad_circle; d += rad_circle / accuracy)
		{
			vec2 check_pos = v_vTexcoord + i * vec2 (cos(d) * size.x, -sin(d) * size.y);
			vec4 datPixel =  v_vColour * texture2D( gm_BaseTexture, check_pos);
			
			bool out_bound = check_pos.x < uvs.r || check_pos.y < uvs.g || check_pos.x > uvs.b || check_pos.y > uvs.a; 
			
			if (datPixel.a > tol && baseColor.a <= tol && !out_bound)
			{
				outline = i;
				break;
			}
		}
		
		if (outline > 0.0) 
		{
			baseColor.a = (1.0 - (outline / thick));
			break;
		}
	}
	
	baseColor.a *= 0.15;
	
	if (baseColor.a > 0.0)
	{
		baseColor.rgb = vec3(0.0);
	}
	//baseColor.a = 1.0;

	//if ( baseColor.a < 0.3 ) 
	//{ 
		//discard; 
	//}

	gl_FragColor = baseColor;
}

