//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 size;
uniform float thick;
uniform vec3 color;
uniform vec4 uvs;
uniform float glow;
uniform float time;

const float rad_circle = 6.28319;

float random (vec2 value) 
{
	return fract(sin(dot(value.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

float noise (vec2 value) 
{
	vec2 i = floor(value);
	vec2 f = fract(value);

	float a = random(i);
	float b = random(i + vec2(1.0, 0.0));
	float c = random(i + vec2(0.0, 1.0));
	float d = random(i + vec2(1.0, 1.0));

	vec2 u = smoothstep(0. ,1. , f);

	return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

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
			break;
		}
	}
	
	vec2 noiseMap = v_vTexcoord * 55.0;
	noiseMap.x += time / 900.;
	noiseMap.y += time / 300.;
	
	if (outline > 0.0) 
	{
		baseColor = vec4(
		color.rgb,
		pow(1.0 - (outline / thick), 5.0)
		);
		
		if (outline == 1.0)
		{
			baseColor.a += 0.25;
		}
		
		if (baseColor.a >= 0.3)
		{ 
			if (glow > 0.0 && glow <= 0.35)
			{
				baseColor.rgb += abs(sin(time / 300.)) * glow * 0.8;
				baseColor.a += abs(sin(time / 300.)) * glow * 0.8;
				baseColor.a += glow * 0.8;
				
				baseColor.a -= noise(noiseMap) * 0.5;
			}
			else
			{
				baseColor.rgb += glow * 0.05;
				baseColor.a += glow * 0.1;
			}
		}
	}
	
	if ( baseColor.a < 0.3 ) 
	{ 
		discard; 
	}
		
	gl_FragColor = baseColor;
}

