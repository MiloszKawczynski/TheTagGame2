if (live_call()) return live_result;

if (global.debugIsGravityOn)
{
	scr_platformerMovement();
	scr_platformerCollision();
}
else
{
	scr_topDownMovement();
	scr_topDownCollision();
}

if (hspeed == 0)
{
	sprite_index = s_cleaIdle;
}
else
{
	image_xscale = sign(hspeed);
	
	if (abs(hspeed) > maximumDefaultSpeed)
	{
		sprite_index = s_cleaRun;
	}
	else
	{
		sprite_index = s_cleaWalk;
	}
}

mask_index = s_idleCycle;