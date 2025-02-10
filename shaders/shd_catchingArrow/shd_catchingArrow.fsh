//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform vec3 color;
uniform vec3 colorTo;
uniform float pathLength;
uniform float offset;

void main()
{
	vec4 baseColor = texture2D(gm_BaseTexture, v_vTexcoord);
	
	baseColor.rgb = mix(color, colorTo, (v_vTexcoord.y + offset) / pathLength);
	
	if (baseColor.a == 0.0)
	{
		baseColor.a = 0.25;
	}
	
	float fadeMargin = 0.1;
	float pixelMargin = (fadeMargin * pathLength);
	
	if (v_vTexcoord.x > 1.0)
	{
		baseColor.a = pow(1.0 - (v_vTexcoord.x - 1.0), 5.0);
		baseColor.rgb += pow(1.0 - (v_vTexcoord.x - 1.0), 2.0) * 0.5;
	}
	
	if (v_vTexcoord.x < 0.0)
	{
		baseColor.a = pow(1.0 - abs(v_vTexcoord.x), 5.0);
		baseColor.rgb += pow(1.0 - abs(v_vTexcoord.x), 2.0) * 0.5;
	}
	
	if (v_vTexcoord.y < pixelMargin - offset)
	{
		baseColor.a -= pixelMargin - v_vTexcoord.y - offset;
	}
	
	if (v_vTexcoord.y > pathLength - pixelMargin - offset)
	{
		baseColor.a -= v_vTexcoord.y - (pathLength - pixelMargin - offset);
	}
	
	gl_FragColor = baseColor;
}

