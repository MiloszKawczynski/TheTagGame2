varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform sampler2D character;

void main()
{
	vec4 baseColor = texture2D( gm_BaseTexture, v_vTexcoord );	
    
    vec4 mask = texture2D( character, v_vTexcoord );
    baseColor.a *= mask.a;
	
	gl_FragColor = baseColor;
}

