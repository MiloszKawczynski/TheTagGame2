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

if (maximumSpeed > maximumDefaultSpeed)
{
	while (ds_list_size(afterimageList) >= floor(maximumSpeed - maximumDefaultSpeed))
	{
		if (ds_list_size(afterimageList) == 0)
		{
			break;
		}
		
		ds_list_delete(afterimageList, 0);
	}
	
	var afterimage = 
	{
	    xx: x,
	    yy: y,
		spriteIndex: sprite_index,
	    imageIndex: image_index,
	    xScale: image_xscale,
	    yScale: image_yscale
	};

	ds_list_add(afterimageList, afterimage);
}
else
{
	ds_list_delete(afterimageList, 0);
}