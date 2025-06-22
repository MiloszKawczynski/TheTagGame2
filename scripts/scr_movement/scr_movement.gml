function place_meeting_precise(x2, y2, obj)
{
    var times30 = (speed div 30);
    
    var halfDistX = (x + x2) / 2;
    var halfDistY = (y + y2) / 2;
    
    repeat (times30) 
    {
        if (!place_meeting(halfDistX, halfDistY, obj))
        {
        	halfDistX = (x + halfDistX) / 2;
        	halfDistY = (y + halfDistY) / 2;
        }
        else 
        {
            return place_meeting(halfDistX, halfDistY, obj);
        }
    }
    
    return place_meeting(x2, y2, obj);
}

function instance_place_precise(x2, y2, obj)
{
    var times30 = (speed div 30);
    
    var halfDistX = (x + x2) / 2;
    var halfDistY = (y + y2) / 2;
    
    repeat (times30) 
    {
        if (instance_place(halfDistX, halfDistY, obj) == noone)
        {
        	halfDistX = (x + halfDistX) / 2;
        	halfDistY = (y + halfDistY) / 2;
        }
        else 
        {
            return instance_place(halfDistX, halfDistY, obj);
        }
    }
    
    return instance_place(x2, y2, obj);
}



function scr_topDownMovement()
{	
	isGrounded = true;
    isAirDashUsed = false;
    jumpNumber = maxJumpNumber - 1;

	desiredHorizontalDirection = input_check("rightKey", player) - input_check("leftKey", player);
	desiredVerticalDirection = input_check("downKey", player) - input_check("upKey", player);
    
    if (o_gameManager.logicState == o_gameManager.breathState)
    {
        desiredHorizontalDirection = 0;
        desiredVerticalDirection = 0;
    }
	
	horizontalSpeed += desiredHorizontalDirection * acceleration;
	verticalSpeed += desiredVerticalDirection * acceleration;
	
	if (desiredHorizontalDirection == 0)
	{
		horizontalSpeed -= sign(horizontalSpeed) * deceleration;
	}
	
	if (desiredVerticalDirection == 0)
	{
		verticalSpeed -= sign(verticalSpeed) * deceleration;
	}
	
	var potentialSpeed = point_distance(0, 0, horizontalSpeed, verticalSpeed);
	if (potentialSpeed > maximumSpeed)
	{
		var potentialToMaximumRatio = potentialSpeed / maximumSpeed;
	
		horizontalSpeed /= potentialToMaximumRatio;
		verticalSpeed /= potentialToMaximumRatio;
	}
	
	speed = point_distance(0, 0, horizontalSpeed, verticalSpeed);
	if (instance_exists(o_debugController) and global.debugCameraAxis and !DEBUG)
	{
		direction = point_direction(0, 0, horizontalSpeed, verticalSpeed) + Camera.Forward;
	}
	else
	{
		direction = point_direction(0, 0, horizontalSpeed, verticalSpeed);
	}
	
	if (abs(speed) < deceleration)
	{
		speed = 0;
	}
	
	if (abs(horizontalSpeed) < deceleration)
	{
		horizontalSpeed = 0;
	}
	
	if (abs(verticalSpeed) < deceleration)
	{
		verticalSpeed = 0;
	}
	
	if (speed > maximumSpeed)
	{
		speed -= deceleration;
		speed = max(speed, maximumSpeed);
	}
	
	if (speed < maximumSpeed and (desiredHorizontalDirection != 0 or desiredVerticalDirection != 0))
	{
		speed += acceleration;
		speed = min(speed, maximumSpeed);
	}
	
	if (speed > deceleration * 2)
	{
		lastDirection = direction;
	}
	
	scr_TopDownObstaclesInteraction();
	
    if !(skillType == skillTypes.float and isSkillActive)
    {
    	if (maximumSpeed > maximumDefaultSpeed)
    	{
    		maximumSpeed -= maximumSpeedDecelerationFactor;
    		maximumSpeed = max(maximumSpeed, maximumDefaultSpeed);
    	}
    	
    	if (maximumSpeed < maximumDefaultSpeed)
    	{
    		maximumSpeed += maximumSpeedDecelerationFactor;
    		maximumSpeed = min(maximumSpeed, maximumDefaultSpeed);
    	}
    }
    
    if (skillType == skillTypes.drift and isSkillActive)
    {
        direction = driftDirection;
        horizontalSpeed = 0;
        verticalSpeed = 0;
        speed = min(driftSpeed, maximumSpeed);
    }
}

function scr_TopDownObstaclesInteraction()
{
	var obst = instance_nearest(x, y, o_obstacleParent);
	if (obst == noone)
	{
		return;
	}
	var dist = point_distance(x, y, obst.x, obst.y);
	if (dist < obstacleRange)
	{
		if (input_check_pressed("interactionKey", player))
		{
            if (pasive.alwaysPerfectVault)
            {
                dist = 0;
            }
            
			var obstacleSpeedBoost = lerp(minimumObstacleJumpForce, maximumObstacleJumpForce, 1 - (dist / obstacleRange));
			
			obst.success = 0.5;
			if (1 - (dist / obstacleRange) > 0.65)
			{
				log("PERFECT VAULT!", c_aqua);
				obst.success = 1;
                audio_play_sound(sn_perfectVault, 0, false, random_range(0.93, 1.07));
			}
            else 
            {
            	audio_play_sound(sn_vault, 0, false, random_range(0.93, 1.07));
            }
			
			if (abs(point_direction(0, 0, horizontalSpeed, verticalSpeed) - point_direction(0, 0, desiredHorizontalDirection, desiredVerticalDirection)) > 50)
			{
				log("EPIC TURN!", c_aqua);
			}
			
			if (speed != 0)
			{
				var newSpeedRatio = (speed + obstacleSpeedBoost) / speed;
				
				if (desiredHorizontalDirection == 0)
				{
					horizontalSpeed *= newSpeedRatio;
				}
				else 
				{
					horizontalSpeed = (abs(horizontalSpeed) * newSpeedRatio) * desiredHorizontalDirection;
				}
				
				if (desiredVerticalDirection == 0)
				{
					verticalSpeed *= newSpeedRatio;
				}
				else 
				{
					verticalSpeed = (abs(verticalSpeed) * newSpeedRatio) * desiredVerticalDirection;
				}
			}
			else
			{
				horizontalSpeed = lengthdir_x(obstacleSpeedBoost, lastDirection);
				verticalSpeed = lengthdir_y(obstacleSpeedBoost, lastDirection);
			}
			
			speed = point_distance(0, 0, horizontalSpeed, verticalSpeed);
			
			if (!global.debugEdit)
			{
				direction = point_direction(0, 0, horizontalSpeed, verticalSpeed) + Camera.Forward;
			}
			else
			{
				direction = point_direction(0, 0, horizontalSpeed, verticalSpeed);
			}
			
			if (speed > maximumSpeed)
			{
				maximumSpeed = speed;
			}
			
			topDownAnimationState = changeState(true, topDownAnimationState, topDownParkourState);
		}
	}
}

function scr_platformerMovement()
{	
	horizontalSpeed = hspeed;
	verticalSpeed = vspeed;
	
	desiredHorizontalDirection = input_check("rightKey", player) - input_check("leftKey", player);
    
    if (o_gameManager.logicState == o_gameManager.breathState)
    {
        desiredHorizontalDirection = 0;
    }
	
	horizontalSpeed += desiredHorizontalDirection * acceleration;
		
	jumpBuffor = armez_timer(jumpBuffor, -1);
	
    var wallDirection = place_meeting_precise(x + 1, y - 1, o_collision) - place_meeting_precise(x - 1, y - 1, o_collision);
    if (wallDirection != 0)
    {
        lastWallDirection = wallDirection;
    }
    
	if (input_check_pressed("jumpKey", player) or jumpBuffor > 0)
	{
        if (pasive.wallJump and !place_meeting_precise(x, y + 1, o_collision) and !isGrounded and (wallDirection != 0 or wallJumpCoyoteTime > 0))
	    {
            wallDirection = 0;
            jumpBuffor = 0;
            wallJumpCoyoteTime = 0;
   			isGrounded = false;
            horizontalSpeed = (jumpForce + momentumJumpForce) * -lastWallDirection * 0.7;
		    verticalSpeed = -(jumpForce + momentumJumpForce) * 0.7;
            maximumSpeed = abs(horizontalSpeed);
	    }
		else if (isGrounded or jumpNumber > 0 or coyoteTime > 0)
		{	
            jumpNumber--;
			jumpBuffor = 0;
			coyoteTime = 0;
			isGrounded = false;
			verticalSpeed = -(jumpForce + momentumJumpForce * min((abs(horizontalSpeed) / maximumDefaultSpeed), 1));
		}
        else if (pasive.airDash and !isAirDashUsed)
        {
            var dir = sign(desiredHorizontalDirection);
            if (dir == 0)
            {
                dir = sign(image_xscale);
            }
            
            airHorizontalSpeed += dir * jumpForce;
            
            isAirDashUsed = true;
            
            part_emitter_region(runTrailSystem, 0, x - 5, x + 5, y - 32, y, ps_shape_rectangle, ps_distr_linear);
            if (sign(image_xscale) == 1)
            {
                part_type_direction(airDashType, 180 - 5, 180 + 5, 0, 0);
            }
            
            if (sign(image_xscale) == -1)
            {
            	part_type_direction(airDashType, 0 - 5, 0 + 5, 0, 0);
            }
            part_emitter_burst(runTrailSystem, 0, airDashType, 32);
        }
        else
		{
			if (jumpBuffor == 0)
			{
				jumpBuffor = maximumJumpBuffor;
			}
		}
	}
	
	if (!isGrounded)
	{		
        if (wallDirection != 0 and pasive.wallJump)
        {
            wallJumpCoyoteTime = maximumCoyoteTime;
        }
        
		verticalSpeed += gravitation;
        
        if (skillType == skillTypes.float)
        {
            if (verticalSpeed > 0)
            {
                if (isSkillActive)
                {
                    verticalSpeed = gravitation * skillValue;
                    
                    if (place_meeting_precise(x, y + verticalSpeed * 2, o_collision))
                    {
                        verticalSpeed = 0;
                    }
                }   
            }
            else 
            {
            	isSkillActive = false;
            }
        }
        
		coyoteTime = armez_timer(coyoteTime, -1);
        
        if (wallDirection == 0)
        { 
            wallJumpCoyoteTime = armez_timer(wallJumpCoyoteTime, -1);   
        }
	}
	
	if (desiredHorizontalDirection == 0)
	{
		horizontalSpeed -= sign(horizontalSpeed) * deceleration;
	}

	horizontalSpeed = clamp(horizontalSpeed, -maximumSpeed, maximumSpeed);
    horizontalSpeed += airHorizontalSpeed;
    airHorizontalSpeed = lerp(airHorizontalSpeed, 0, 0.1);
	
	speed = point_distance(0, 0, horizontalSpeed, verticalSpeed);
	
	direction = point_direction(0, 0, horizontalSpeed, verticalSpeed);
	
	if (abs(hspeed) < deceleration * (maximumSpeed / maximumDefaultSpeed))
	{
		hspeed = 0;
	}
	
	if (isGrounded)
	{			
		if (instance_place_precise(x, y + 1, o_collision) != noone)
		{
			groundImOn = instance_place_precise(x, y + 1, o_collision);
		}
		
		if (!place_meeting_precise(x, y + 1, o_collision) and groundImOn != noone)
		{
			isGrounded = false;
            jumpNumber--;
			
			if (vspeed == 0)
			{
				var verticalDirection = 1
				if (groundImOn.image_xscale == image_xscale)
				{
					verticalDirection = -1
				}
				
				if (groundImOn.object_index == o_slope)
				{
					vspeed = abs(hspeed) * 0.5 * verticalDirection;
				}
				
				if (groundImOn.object_index == o_ramp)
				{			
					vspeed = abs(hspeed) * 0.25 * verticalDirection;
				}
			}
		}
	}
	
	scr_platformerObstaclesInteraction()
	
	if (abs(hspeed) < deceleration)
	{
		maximumSpeed = maximumDefaultSpeed;
	}
	
	if (hspeed != 0)
	{
		image_xscale = sign(hspeed);
	}
	
	if (desiredHorizontalDirection != 0)
	{
		if (place_meeting_precise(x, y + 1, o_block) and isGrounded)
		{
			if (maximumSpeed > maximumDefaultSpeed)
			{
				maximumSpeed -= maximumSpeedDecelerationFactor * maximumSpeedDecelerationFactor;
				maximumSpeed = max(maximumSpeed, maximumDefaultSpeed);
			}
			
			if (maximumSpeed < maximumDefaultSpeed)
			{
				maximumSpeed += maximumSpeedDecelerationFactor;
				maximumSpeed = min(maximumSpeed, maximumDefaultSpeed);
			}
		}
	}
	
	if (hspeed != 0 and instance_place_precise(x, y + 1, o_diagonal) != noone)
	{
		if (instance_place_precise(x, y + 1, o_diagonal).image_xscale != image_xscale)
		{
			if (place_meeting_precise(x, y + 1, o_ramp))
			{
				maximumSpeed += rampAcceleration;
			}
			
			if (place_meeting_precise(x, y + 1, o_slope))
			{
				maximumSpeed += slopeAcceleration;
			}
		}
		else
		{
			if (place_meeting_precise(x, y + 1, o_slope))
			{
				maximumSpeed -= slopeDeceleration;
				maximumSpeed = max(maximumSpeed, slopeMinSpeed);
			}
			
			if (place_meeting_precise(x, y + 1, o_ramp))
			{
				maximumSpeed -= rampDeceleration;
				maximumSpeed = max(maximumSpeed, rampMinSpeed);
			}
		}
	}
    
    if (skillType == skillTypes.drift and isSkillActive)
    {
        hspeed = min(driftSpeed, maximumSpeed);
        horizontalSpeed = min(driftSpeed, maximumSpeed);
    }
}

function scr_platformerObstaclesInteraction()
{
	var obst = instance_nearest(x, y, o_obstacleParent);
	if (obst == noone)
	{
		return;
	}
	var dist = point_distance(x, y, obst.x, obst.y);
	if (dist < obstacleRange)
	{
		if (input_check_pressed("interactionKey", player))
		{
			obst.success = 0.5;
            
            if (pasive.alwaysPerfectVault)
            {
                dist = 0;
            }
            
			if (1 - (dist / obstacleRange) > 0.65)
			{
				log("PERFECT VAULT!", c_aqua);
				obst.success = 1;
			    audio_play_sound(sn_perfectVault, 0, false, random_range(0.93, 1.07));
			}
            else 
            {
            	audio_play_sound(sn_vault, 0, false, random_range(0.93, 1.07));
            }
			
			vspeed -= lerp(minimumObstacleJumpForce, maximumObstacleJumpForce, 1 - (dist / obstacleRange));
			if (desiredHorizontalDirection != sign(hspeed))
			{
				hspeed = abs(hspeed) * desiredHorizontalDirection;
				log("EPIC TURN!", c_aqua);
			}
			
			platformAnimationState = changeState(true, platformAnimationState, platformParkourState);
		}
	}
}

function scr_topDownCollision()
{	
    if (place_meeting_precise(x + hspeed, y + vspeed, o_collision) and desiredHorizontalDirection != 0 and desiredVerticalDirection != 0)
	{
        if (instance_place_precise(x + hspeed, y + vspeed, o_collision).object_index != o_block)
        {
            if (hspeed != 0 and vspeed != 0)
            {
                if (abs(hspeed) > abs(vspeed))
                {
    		        vspeed = 0;
    		        verticalSpeed = 0;
                }
                else if (abs(hspeed) < abs(vspeed))
                {
                	hspeed = 0;
                    horizontalSpeed = 0;
                }
            }
        }
	}
    
    
	if (place_meeting_precise(x + hspeed, y, o_collision))
	{
		if (!place_meeting(x + hspeed, y - abs(hspeed * 2) - 1, o_collision))
		{
			while (place_meeting(x + hspeed, y, o_collision))
			{
				y -= 0.5;
			}
		}
		else if (!place_meeting(x + hspeed, y + abs(hspeed * 2) + 1, o_collision))
		{
			while (place_meeting(x + hspeed, y, o_collision))
			{
				y += 0.5;
			}
		}
		else
		{
			while (!place_meeting(x + sign(hspeed), y, o_collision))
			{
				x += sign(hspeed) * 0.5;
			}
			
			hspeed = 0;
			horizontalSpeed = 0;
			maximumSpeed = maximumDefaultSpeed;
		}
	}
	
	if (place_meeting(x, y + vspeed, o_collision))
	{
		if (!place_meeting(x - abs(vspeed * 2) - 1, y + vspeed, o_collision))
		{
			var isRamp = false;
			var yy = y;
			while(!place_meeting(x, yy, o_collision))
			{
				yy += sign(vspeed) * 0.5;
			}
			
			if (instance_place(x, yy, o_collision).object_index == o_ramp)
			{
				isRamp = true;
			}
			
			var xx = x
			while (place_meeting(x, y + vspeed, o_collision))
			{
				x -= 0.5;
			}
			if (isRamp)
			{
				x = (x + xx) / 2
				y -= vspeed / 2;
			}
		}
		else if (!place_meeting(x + abs(vspeed * 2) + 1, y + vspeed, o_collision))
		{
			var isRamp = false;
			var yy = y;
			while(!place_meeting(x, yy, o_collision))
			{
				yy += sign(vspeed) * 0.5;
			}
			
			if (instance_place(x, yy, o_collision).object_index == o_ramp)
			{
				isRamp = true;
			}
			
			var xx = x
			while (place_meeting(x, y + vspeed, o_collision))
			{
				x += 0.5;
			}
			if (isRamp)
			{
				x = (x + xx) / 2;
				y -= vspeed / 2;
			}
		}
		else
		{
			while (!place_meeting(x, y + sign(vspeed), o_collision))
			{
				y += sign(vspeed) * 0.5;
			}
			
			vspeed = 0;
			verticalSpeed = 0;
			maximumSpeed = maximumDefaultSpeed;
		}
	}
}

function scr_platformerCollision()
{	
	if (vspeed < 0)
	{
		if (place_meeting_precise(x, y + vspeed, o_collision))
		{	
			var slopeSlide = false;
			
			if (desiredHorizontalDirection != 1 and !place_meeting_precise(x - abs(vspeed * 2) - 1, y + vspeed, o_collision))
			{
				while (place_meeting_precise(x, y + vspeed, o_collision))
				{
					x -= 0.5;
				}
				slopeSlide = true;
			}
			
			if (desiredHorizontalDirection != -1 and !place_meeting_precise(x + abs(vspeed * 2) + 1, y + vspeed, o_collision))
			{
				while (place_meeting_precise(x, y + vspeed, o_collision))
				{
					x += 0.5;
				}
				slopeSlide = true;
			}
			
			if (!slopeSlide)
			{
				while(place_free(x, y + sign(vspeed) * 0.5))
				{
					y += sign(vspeed) * 0.5;
				}
				vspeed = 0;
			}
		}
	}
	
	if (vspeed > 0)
	{
		if (place_meeting_precise(x, y + vspeed, o_collision) or (vspeed == gravitation * 5 and place_meeting_precise(x, y + vspeed * 2, o_collision)))
		{	
			while(place_free(x, y + sign(vspeed) * 0.5))
			{
				y += sign(vspeed) * 0.5;
			}
		
			if (!isGrounded)
			{
				if (place_meeting_precise(x, y + 1, o_diagonal))
				{
					if (instance_place_precise(x, y + 1, o_diagonal).image_xscale != sign(horizontalSpeed) and hspeed != 0 and instance_place_precise(x, y + 1, o_diagonal).image_yscale == 1)
					{
						hspeed += vspeed * slopeSpeedTransitionFactor * image_xscale;
						if (abs(hspeed) > maximumSpeed)
						{
							maximumSpeed = abs(hspeed);
						}
					}
				}
		
				if (place_meeting_precise(x, y + 1, o_collision))
				{
					isGrounded = true;
                    isAirDashUsed = false;
                    jumpNumber = maxJumpNumber;
					canBeOnCliff = false;
					coyoteTime = maximumCoyoteTime;
                    wallJumpCoyoteTime = 0;
				}
			}
		
			vspeed = 0;
		}
	}
	
	if (place_meeting_precise(x + hspeed, y, o_collision))
	{
		if (!place_meeting_precise(x + hspeed, y - abs(hspeed) - 1, o_collision))
		{
			while (place_meeting_precise(x + hspeed, y, o_collision))
			{
				y -= 0.5;
			}
		}
		else
		{
			if (!place_meeting_precise(x + hspeed, y + abs(hspeed) + 1, o_collision))
			{
				while (place_meeting_precise(x + hspeed, y, o_collision))
				{
					y += 0.5;
				}
			}
			else
			{
				while (!place_meeting_precise(x + sign(hspeed), y, o_collision))
				{
					x += sign(hspeed) * 0.5;
				}
				
				hspeed = 0;
                maximumSpeed = maximumDefaultSpeed;
                airHorizontalSpeed = 0;
			}
		}
	}
	
	if (vspeed >= 0 and !place_meeting_precise(x + hspeed, y + 1, o_collision) and place_meeting_precise(x + hspeed, y + ceil(abs(hspeed)) + 1, o_collision))
	{
		while (!place_meeting_precise(x + hspeed, y + 0.5, o_collision))
		{
			y += 0.5;
		}
	}
	
	if (place_meeting_precise(x + hspeed, y + vspeed, o_collision) and abs(vspeed) >= 1)
	{
		var collisionObject = instance_place_precise(x + hspeed, y + vspeed, o_collision);
		
		while (place_free(x + sign(hspeed), y + sign(vspeed)))
		{
			x += sign(hspeed) * 0.5;
			y += sign(vspeed) * 0.5;
		}
		
		vspeed = 0;
		
		x -= hspeed;
		x -= sign(hspeed);
	}
}