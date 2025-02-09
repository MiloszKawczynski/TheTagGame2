varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float circleRadius;
uniform float direction;
uniform float success;

void main()
{
    vec4 baseColor = texture2D(gm_BaseTexture, v_vTexcoord);
    vec2 uv = v_vTexcoord * 2.0 - 1.0;
    float dist = length(uv);
	
	float perfectCircle = 0.35 + (success * 0.15);
	
	float shaderRadius = circleRadius;
	
	baseColor.a = 0.0;
	
	if (dist <= perfectCircle)
	{
		baseColor.a = pow(dist / perfectCircle, 5.0 - (success * 5.0));
		baseColor.rgb += (success * 0.5);
	}
	
	if (dist >= shaderRadius - 0.05 && dist <= shaderRadius)
	{
		if (dist <= 1.0)
		{
			vec2 dir = vec2(cos(radians(direction)), -sin(radians(direction)));
			float distToDir = length(dir - uv);
			
			if (distToDir < 1.0)
			{
				baseColor.a += 0.75;
				baseColor.rgb += 0.75;
			}
		}
	}

    gl_FragColor = baseColor;
}
