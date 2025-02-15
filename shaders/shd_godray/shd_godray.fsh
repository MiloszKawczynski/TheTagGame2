varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float intensivity;	

void main() 
{
    vec4 texColor = texture2D(gm_BaseTexture, v_vTexcoord);
    float alphaMultiplier = intensivity - v_vTexcoord.x;
	
	if ( texColor.a < 0.05 ) { discard; }
	
    gl_FragColor = vec4(texColor.rgb, texColor.a * alphaMultiplier) * v_vColour;
}
