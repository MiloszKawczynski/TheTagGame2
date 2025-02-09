function scr_vignettePulse()
{
	vignetteTime = armez_timer(vignetteTime, 0.025);
	var edges = [1, 1.1];
	edges[0] = 1 - (0.02 * pulseCounter) + animcurve_get_point(ac_vignettePulse, 0, vignetteTime) * (0.25 + 0.1 * pulseCounter);
	edges[1] = 1.1 - (0.02 * pulseCounter) + animcurve_get_point(ac_vignettePulse, 0, vignetteTime) * (0.25 + 0.1 * pulseCounter);
			
	if (vignetteTime == 1)
	{
		vignetteTime = 0;
		vignettePulse = false;
		pulseCounter++;
				
		if (pulseCounter > 3)
		{
			pulseCounter = 0;
		}
	}
		
	var _fx_struct = layer_get_fx("vignette");

	if (_fx_struct != -1)
	{
		var _params = fx_get_parameters(_fx_struct);
		_params.g_VignetteEdges = edges;

		fx_set_parameters(_fx_struct, _params);
	}
}

function scr_vignettePullBack()
{
	var _fx_struct = layer_get_fx("vignette");

	if (_fx_struct != -1)
	{
		var _params = fx_get_parameters(_fx_struct);
		
		var edges = _params.g_VignetteEdges;
		
		edges[0] = lerp(edges[0], 1, 0.04);
		edges[1] = lerp(edges[1], 1.1, 0.04);
		
		_params.g_VignetteEdges = edges;

		fx_set_parameters(_fx_struct, _params);
	}
}

function scr_vignetteReset()
{
	var _fx_struct = layer_get_fx("vignette");

	if (_fx_struct != -1)
	{
		var _params = fx_get_parameters(_fx_struct);
		
		var edges = _params.g_VignetteEdges;
		
		edges[0] = 1;
		edges[1] = 1.1;
		
		_params.g_VignetteEdges = edges;

		fx_set_parameters(_fx_struct, _params);
	}
	
	audio_stop_sound(sn_gravityChangeWarning);
	
	vignetteTime = 0;
	vignettePulse = false;
	pulseCounter = 0;
}