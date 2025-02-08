if (isGameOn or true)
{
	ui.draw();

	if (isChasingTagAlpha > 0 and room == r_levelEditor)
	{
		var instTo = players[whoIsChasing].instance;
		var instFrom = instTo;
		
		if (playerWasCaught)
		{
			whoIsChasingTagPosition[0] = players[!whoIsChasing].instance.x;
			whoIsChasingTagPosition[1] = players[!whoIsChasing].instance.y;
			whoIsChasingTagPosition[2] = 0;
			whoIsChasingTagScale = 1;
			whoIsChasingStage = 0;
			isChasingTagTimer = 0;
			playerWasCaught = false;
		}
		
		var pos = [];
		
		pos = world_to_gui(
			whoIsChasingTagPosition[0],
			whoIsChasingTagPosition[1],
			whoIsChasingTagPosition[2]);
		
		switch(whoIsChasingStage)
		{
			case(0):
			{
				if (point_distance(whoIsChasingTagPosition[0], whoIsChasingTagPosition[1], instTo.x, instTo.y) < 10)
				{
					whoIsChasingStage = 1;
				}
				
				whoIsChasingTagPosition[0] = lerp(whoIsChasingTagPosition[0], instTo.x, 0.1);
				whoIsChasingTagPosition[1] = lerp(whoIsChasingTagPosition[1], instTo.y, 0.1)
				break;
			}
		
			case(1):
			{
				whoIsChasingTagPosition[0] = lerp(whoIsChasingTagPosition[0], instTo.x, 0.1);
				whoIsChasingTagPosition[2] = animcurve_get_point(ac_whoIsChasingChange, 0, isChasingTagTimer) * -15;
				whoIsChasingTagScale = animcurve_get_point(ac_whoIsChasingChange, 1, isChasingTagTimer);
				isChasingTagTimer = armez_timer(isChasingTagTimer, 0.01);
				
				if (whoIsChasingTagScale <= 0.1)
				{
					whoIsChasingStage = 2;
					
					whoIsChasingTagScale = 0;
					part_type_color1(imChasingType, instTo.color);
					part_emitter_region(imChasingSystem, 0, instTo.x - 16, instTo.x + 16, instTo.y - 16, instTo.y + 16, ps_shape_rectangle, ps_distr_linear);
					part_emitter_burst(imChasingSystem, 0, imChasingType, 32);
				}
				
				break;
			}
		}
		
		draw_sprite_ext(s_isChasingTag, 3, pos[0], pos[1] - 60 / Camera.Zoom, (0.4 * whoIsChasingTagScale) / Camera.Zoom, (0.4 * whoIsChasingTagScale) / Camera.Zoom, 0, c_white, 1);
	}
}