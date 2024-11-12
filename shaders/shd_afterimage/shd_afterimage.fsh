// Fragment Shader
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float alphaDecay;
uniform vec3 color;

void main() {
    vec4 col = texture2D(gm_BaseTexture, v_vTexcoord);
	col.a *= alphaDecay;
    col.rgb += (color);
	
	if ( col.a < 0.05 ) { discard; }

    gl_FragColor = col * v_vColour;
}
