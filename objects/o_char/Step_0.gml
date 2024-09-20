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

Camera.MouseLock = mouse_check_button(mb_right);

if (hspeed == 0)
{
	sprite_index = idleCycle;
}
else
{
	image_xscale = sign(hspeed);
	
	if (abs(hspeed) > maximumDefaultSpeed)
	{
		sprite_index = runCycle;
	}
	else
	{
		sprite_index = walkCycle;
	}
}

mask_index = s_clea;