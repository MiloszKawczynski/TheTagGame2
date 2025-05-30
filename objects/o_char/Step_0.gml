z = 0;
if (place_meeting(x, y, o_start))
{
	z = 8;
}

if (o_gameManager.logicState == o_gameManager.freeState
    or o_gameManager.logicState == o_gameManager.gameState
    or o_gameManager.logicState == o_gameManager.breathState
    or o_gameManager.logicState == o_gameManager.pointState)
{
	if (o_gameManager.isGravitationOn)
	{
		scr_platformerMovement();
		scr_platformerCollision();
	}
	else
	{
		scr_topDownMovement();
		scr_topDownCollision();
	}
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
            case(skillTypes.float):
			{
                if (isGrounded and o_gameManager.isGravitationOn)
                { 
                    jumpNumber--;
        			jumpBuffor = 0;
        			coyoteTime = 0;
        			isGrounded = false;
        			verticalSpeed = -skillValue;
                }
                isSkillActive = 1;
                isUsed = true;
				break;
			}
            case(skillTypes.drift):
			{
				if (isGrounded and isSkillActive == 0) 
				{
                    isSkillActive = 1;
                    driftDirection = lastDirection; 
                    if (o_gameManager.isGravitationOn)
					{
                        driftSpeed = horizontalSpeed;
                    }
                    else
                    {
                        driftSpeed = speed;
                    }
                    driftMeter = skillEnergy;
				}
                
                if (isSkillActive)
                { 
                    if (isGrounded)
                    {
                        isUsed = true;
                    }
                    else 
                    {
                    	isUsed = false;
                        isSkillActive = 0;
                        skillUsed = true;
                    }
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
else 
{
	if (skill == skillTypes.float) 
    { 
        isSkillActive = 0;
    }
    
    if (skill == skillTypes.drift) 
    { 
        if (isSkillActive)
        {
            isSkillActive = 0;
            
            if (o_gameManager.isGravitationOn)
            {
                var dir = sign(desiredHorizontalDirection);
                if (dir == 0)
                {
                    dir = sign(image_xscale);
                }
                
                horizontalSpeed = (max(hspeed, maximumSpeed) + (abs(driftMeter - skillEnergy) / 1) * skillValue) * dir;
                hspeed = horizontalSpeed;
                maximumSpeed = abs(horizontalSpeed);
                scr_platformerCollision();
            }
            else
            { 
                speed = max(speed, maximumSpeed) + (abs(driftMeter - skillEnergy) / 1) * skillValue;
                maximumSpeed = speed;
                
                if (desiredHorizontalDirection == 0 and desiredVerticalDirection == 0)
                {
                    direction = lastDirection;
                }
                else 
                {
                	direction = point_direction(0, 0, desiredHorizontalDirection, desiredVerticalDirection);
                }
                horizontalSpeed = lengthdir_x(speed, direction);
                verticalSpeed = lengthdir_y(speed, direction);
                scr_topDownCollision();
            }
        }
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

if (o_gameManager.logicState == o_gameManager.gameState and o_gameManager.whoIsChasing == player)
{
	nearestPlayer = instance_nearest_notme(x, y, o_char);

	if (distance_to_object(nearestPlayer) < obstacleRange and !collision_line(x, y, nearestPlayer.x, nearestPlayer.y, o_collision, true, true))
	{
		if (!canCaught)
		{
			thick = 40;
			glow = 5;
		}
		
		canCaught = true;
	}
	else
	{
		if (canCaught)
		{
			thick = 7;
			glow = 0;
		}
		
		canCaught = false;
	}
	
	if (canCaught)
	{
		if (input_check_pressed("interactionKey", player) or pasive.autoCatch)
		{
            o_gameManager.caught();
		}
	}
}

if (o_gameManager.isGravitationOn)
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

if ((!o_gameManager.isGravitationOn or (isGrounded or coyoteTime != 0 or vspeed < jumpForce * -0.75)) and speed >= maximumDefaultSpeed)
{
	part_type_direction(runTrailType, direction + 180 - 5, direction + 180 + 5, 0, 2);
	part_emitter_region(runTrailSystem, 0, x - 8, x + 8, y - 4, y + 4, ps_shape_rectangle, ps_distr_linear);
	part_emitter_stream(runTrailSystem, 0, runTrailType, 1);
}
else
{
	part_emitter_stream(runTrailSystem, 0, runTrailType, 0);
}

if (!isReady and input_check_long_pressed("interactionKey", player))
{
    isReady = true;
}