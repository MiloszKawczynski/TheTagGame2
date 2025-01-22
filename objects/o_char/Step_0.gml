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

var isUsed = false;

if (skillUsed and input_check_pressed("skillKey", player))
{
	skillUsed = false;
}

if (input_check("skillKey", player) and !skillRecharging and !skillUsed)
{
	if (skillEnergy >= skillUsage)
	{
		switch(skill)
		{
			case(skillTypes.sprint):
			{
				if (speed != 0 and isGrounded) 
				{
					if (maximumSpeed < maximumDefaultSpeed * 1.59)
					{
						maximumSpeed += skillValue;
					}
					isUsed = true;
				}
				break;
			}
			case(skillTypes.dash):
			{
				if (speed != 0 and isGrounded)
				{
					if (o_gameManager.isGravitationOn)
					{
						horizontalSpeed = maximumSpeed * skillValue * sign(hspeed);
						maximumSpeed = abs(horizontalSpeed);
					}
					else 
					{
						horizontalSpeed = lengthdir_x(maximumSpeed * skillValue, direction);
						verticalSpeed = lengthdir_y(maximumSpeed * skillValue, direction);
						maximumSpeed = point_distance(0, 0, horizontalSpeed, verticalSpeed);
					}
					isUsed = true;
				}
				break;
			}
			case(skillTypes.jumpBack):
			{
				if (speed != 0 and isGrounded) 
				{
					if (o_gameManager.isGravitationOn)
					{
						desiredHorizontalDirection *= -1; 
						hspeed *= -1;
						horizontalSpeed = hspeed;
						maximumSpeed += skillValue;
						y -= abs(horizontalSpeed);
						scr_platformerCollision();
					}
					else 
					{
						desiredHorizontalDirection *= -1; 
						desiredVerticalDirection *= -1;
						direction += 180; 
						horizontalSpeed = lengthdir_x(maximumSpeed + skillValue, direction);
						verticalSpeed = lengthdir_y(maximumSpeed + skillValue, direction);
						maximumSpeed = point_distance(0, 0, horizontalSpeed, verticalSpeed);
					}
					skillUsed = true;
					isSkillActive = 3;
					isUsed = true;
				}
				break;
			}
		}
	}
	else 
	{
		skillRecharging = true;
		skillUsed = true;
	}
}

if (!isUsed)
{
	skillEnergy += skillReplenish;
	
	if (skillEnergy >= skillRechargePercentage)
	{
		skillRecharging = false;
	}
}
else 
{ 
	skillEnergy -= skillUsage;
}

skillEnergy = clamp(skillEnergy, 0, 1);

if (o_gameManager.whoIsChasing == player)
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
		if (input_check_pressed("interactionKey", player))
		{
			o_gameManager.caught();
		}
	}
}

if (global.debugIsGravityOn)
{
	platformAnimationState();
}
else 
{
	topDownAnimationState();
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
	    _stretch: stretch,
		_squash: squash,
		rotation: angle
	};

	ds_list_add(afterimageList, afterimage);
}
else
{
	ds_list_delete(afterimageList, 0);
}

if ((!global.debugIsGravityOn or (isGrounded or coyoteTime != 0 or vspeed < jumpForce * -0.75)) and speed >= maximumDefaultSpeed)
{
	part_type_direction(runTrailType, direction + 180 - 5, direction + 180 + 5, 0, 2);
	part_emitter_region(runTrailSystem, 0, x - 8, x + 8, y - 4, y + 4, ps_shape_rectangle, ps_distr_linear);
	part_emitter_stream(runTrailSystem, 0, runTrailType, 1);
}
else
{
	part_emitter_stream(runTrailSystem, 0, runTrailType, 0);
}