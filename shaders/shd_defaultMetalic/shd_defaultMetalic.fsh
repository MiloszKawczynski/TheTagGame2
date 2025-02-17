varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec3 v_vNormal;
varying vec3 v_vWorldPosition;
varying vec3 v_vPosition;

uniform vec3 ambient_color;
uniform vec3 sun_color;
uniform vec3 sun_pos;
uniform float sun_intensity;

uniform float lightTotal;
uniform vec3 lightPos[64];
uniform vec3 lightColor[64];
uniform float lightRange[64];
uniform float lightIsCone[64];
uniform vec3 lightDirection[64];
uniform float lightCutoffAngle[64];

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

// Pointlights
float evaluate_point_light(vec3 world_position, vec3 world_normal, vec3 light_position, float light_radius)
{
	vec3 lightIncome = world_position - light_position;
	float lightDist = length(lightIncome);
	lightIncome = normalize(-lightIncome);
	float lDiff = max(dot(world_normal, lightIncome), 0.);

	float lightAtt = clamp(1. - lightDist * lightDist / (light_radius * light_radius), 0., 1.); 
	lightAtt *= lightAtt;

	return lightAtt * lDiff;
}

// Spotlights
float evaluate_cone_light(vec3 world_position, vec3 world_normal, vec3 light_direction, float cutoff, vec3 light_position, float light_radius)
{
	vec3 lightIncome = world_position - light_position;
	float lightDist = length(lightIncome);
	lightIncome = normalize(-lightIncome);
	float lDiff = max(dot(world_normal, lightIncome), 0.);

	float cAng = max(dot(lightIncome, -normalize(light_direction)), 0.);
	float lightAtt = 0.;

	if (cAng > cutoff) {
		lightAtt = max((light_radius - lightDist) / light_radius, 0.);
	}

	return lightAtt * lDiff;
}

void main()
{
	vec4 col = texture2D(gm_BaseTexture, v_vTexcoord) * v_vColour;

	if (col.a < 0.05) { discard; }
	
	float noiseValue = noise(v_vWorldPosition.xy * 0.02);
	
	vec3 perturbedNormal = normalize(v_vNormal + vec3(noiseValue * 2.0 - 1.0, noiseValue * 2.0 - 1.0, 0.0) * 0.2);
	vec3 lightDir = normalize(-sun_pos);
	float _diff = max(dot(perturbedNormal, lightDir), 0.0);
	
	if (v_vWorldPosition.z >= 30.0 && length(col.rgb - (vec3(219., 33., 34.) / 255.0)) <= 0.7)
	{
		float metallicFactor = 0.1;
		float reflection = clamp(_diff * metallicFactor + noiseValue * 0.3, 0.0, 1.0);
		vec3 metallicColor = mix(col.rgb, vec3(1.0, 1.0, 1.0), reflection);
		
		col.rgb = metallicColor * (ambient_color + (sun_color * sun_intensity) * _diff);
	}
	else
	{
		col.rgb *= ambient_color + ( sun_color * sun_intensity ) * _diff;
	}

	// Spot & Point lights
	vec3 col_add = vec3(0);
	if (lightTotal > 0.) {
		float eval = 0.;
		for (int i = 0; i < 64; i++)
		{
			if (float(i) > lightTotal) { break; }

			if (lightIsCone[i] == 1.) {
				eval = evaluate_cone_light(v_vWorldPosition, perturbedNormal, lightDirection[i], lightCutoffAngle[i], lightPos[i], lightRange[i]);
			} else {
				eval = evaluate_point_light(v_vWorldPosition, perturbedNormal, lightPos[i], lightRange[i]);
			}
			col_add += eval * lightColor[i];
		}
	}

	col_add /= max(lightTotal, 1.);
	gl_FragColor = vec4(col.rgb + col_add, col.a);
}

