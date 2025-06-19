//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform vec2 size;
uniform float dotPositionX[100];
uniform float dotPositionY[100];
uniform float dotSize[100];
uniform float dotLight[100];

void main()
{
    vec4 baseColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
    
    for (int i = 0; i < 100; i++)
    {
        vec2 center = vec2(dotPositionX[i], dotPositionY[i]);
    
        vec2 uv = v_vTexcoord - center;
        uv.x *= size.y / size.x;
    
        float dist = length(uv);
        float radius = dotSize[i];
    
        if (dist < radius) 
        {
            baseColor.rgb *= max((1.0 - (dist / radius)) * 8.0 * dotLight[i], 1.0);
            //baseColor.rgb = max(baseColor.rgb, 1.0);
        }
    }
    
    gl_FragColor = baseColor;
}
