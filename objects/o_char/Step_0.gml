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

if (isChasing)
{
	nearestPlayer = instance_nearest_notme(x, y, o_char);

	if (distance_to_object(nearestPlayer) < obstacleRange and !collision_line(x, y, nearestPlayer.x, nearestPlayer.y, o_collision, true, true))
	{
		canCaught = true;
	}
	else
	{
		canCaught = false;
	}
	
	if (canCaught)
	{
		if (keyboard_check_pressed(interactionKey))
		{
			log(string("Player {0} CAUGHT!", player), color);
			o_gameManager.reset();
		}
	}
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