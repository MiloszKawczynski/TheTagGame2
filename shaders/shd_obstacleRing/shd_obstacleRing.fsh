varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float circleRadius;

//Typical pseudo-random hash (white noise).
float hash(vec2 p)
{
    p = mod(p, 7.31); //Bring 'p' to a useful range.
    //Generate a pseudo random number from 'p'.
    return fract(sin(p.x*12.9898 + p.y*78.233) * 43758.5453);
}

//Standard value noise.
float value_noise(vec2 pos)
{
    vec2 cell = floor(pos); //Cell (whole number) coordinates.
    vec2 sub = pos-cell; //Sub-cell (fractional) coordinates.
    sub *= sub*(3.-2.*sub); //Cubic interpolation (comment out for linear interpolation).
    const vec2 off = vec2(0,1); //Offset vector.

    //Sample cell corners and interpolate between them.
    return mix( mix(hash(cell+off.xx), hash(cell+off.yx), sub.x),
                mix(hash(cell+off.xy), hash(cell+off.yy), sub.x), sub.y);
}

float fractal_noise(vec2 pos, int oct, float amp)
{
    float noise_sum = 0.; //Noise total.
    float weight_sum = 0.; //Weight total.
    float weight = 1.; //Octave weight.

    for(int i = 0; i < oct; i++) //Iterate through octaves
    {
        noise_sum += value_noise(pos) * weight; //Add noise octave.
        weight_sum += weight; //Add octave weight.
        weight *= amp; //Reduce octave amplitude by multiplier.
        pos *= mat2(1.6,1.2,-1.2,1.6); //Rotate and scale.
    }
    return noise_sum/weight_sum; //Compute average.
}

void main()
{
    vec4 baseColor = texture2D(gm_BaseTexture, v_vTexcoord);
    vec2 uv = v_vTexcoord * 2.0 - 1.0;
    float dist = length(uv);
	
	if (baseColor.a > 0.0)
	{
		if ((dist / circleRadius) <= 0.8)
		{
			baseColor.a = smoothstep(0.5, 1.0, (dist / (circleRadius * 0.8)));
		}
		else
		{
			baseColor.a = smoothstep(1.0, 0.5, ((dist - (circleRadius * 0.8)) / (circleRadius * 0.2)));
		}
	}
	
	float limit = 0.5;
	if (circleRadius > limit)
	{
		baseColor.a *= smoothstep(1.0, 0.0, (circleRadius - limit) / (limit));
	}
	
	baseColor.r -= fractal_noise(uv, 4, 1.0);
	baseColor.g += fractal_noise(uv * uv, 4, 1.0);
	baseColor.b += fractal_noise(uv * uv * uv, 4, 1.0);

    gl_FragColor = baseColor;// * 0.75;
}
