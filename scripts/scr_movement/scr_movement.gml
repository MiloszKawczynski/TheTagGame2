function scr_topDownMovement()
{	
	isGrounded = true;
	
	if (isSkillActive and skill == skillTypes.jumpBack)
	{
		if (desiredHorizontalDirection * -1 != input_check("rightKey", player) - input_check("leftKey", player)
		or desiredVerticalDirection * -1 != input_check("downKey", player) - input_check("upKey", player)) 
		{
			isSkillActive = false;
		}
		
		isSkillActive--;
	}

	desiredHorizontalDirection = input_check("rightKey", player) - input_check("leftKey", player);
	desiredVerticalDirection = input_check("downKey", player) - input_check("upKey", player);
	
	if (isSkillActive and skill == skillTypes.jumpBack)
	{
		desiredHorizontalDirection *= -1;
		desiredVerticalDirection *= -1;
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
	if (instance_exists(o_debugController) and global.debugCameraAxis and !global.debugEdit)
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
	
	if (isSkillActive and skill == skillTypes.jumpBack)
	{
		if (desiredHorizontalDirection * -1 != input_check("rightKey", player) - input_check("leftKey", player)) 
		{
			isSkillActive = false;
		}
		
		isSkillActive--;
	}
	
	desiredHorizontalDirection = input_check("rightKey", player) - input_check("leftKey", player);
	
	if (isSkillActive and skill == skillTypes.jumpBack)
	{
		desiredHorizontalDirection *= -1;
	}
	
	horizontalSpeed += desiredHorizontalDirection * acceleration;
		
	jumpBuffor = armez_timer(jumpBuffor, -1);
	
    var wallDirection = place_meeting(x + 1, y - 1, o_collision) - place_meeting(x - 1, y - 1, o_collision);
    if (wallDirection != 0)
    {
        lastWallDirection = wallDirection;
    }
    
	if (input_check_pressed("jumpKey", player) or jumpBuffor > 0)
	{
		if (isGrounded or coyoteTime > 0)
		{	
			jumpBuffor = 0;
			coyoteTime = 0;
			isGrounded = false;
			verticalSpeed = -(jumpForce + momentumJumpForce * min((abs(horizontalSpeed) / maximumDefaultSpeed), 1));
		}
		else if (pasive.wallJump and !isGrounded and wallDirection != 0 or wallJumpCoyoteTime > 0)
	    {
            jumpBuffor = 0;
            coyoteTime = 0;
   			isGrounded = false;
            horizontalSpeed = (jumpForce + momentumJumpForce) * 0.5 * -lastWallDirection;
		    verticalSpeed = -(jumpForce + momentumJumpForce) * 0.5;
            maximumSpeed = abs(horizontalSpeed);
	    }
        else
		{
			if (jumpBuffor == 0)
			{
				jumpBuffor = maximumJumpBuffor;
			}
		}
	}
    
    if (wallDirection != 0 and pasive.wallJump)
    {
        wallJumpCoyoteTime = maximumCoyoteTime;
    }
	
	if (!isGrounded)
	{		
		verticalSpeed += gravitation;
        
        if (pasive.float and input_check("upKey", player) and verticalSpeed > 0)
        {
            verticalSpeed = gravitation * 5;
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
	
	speed = point_distance(0, 0, horizontalSpeed, verticalSpeed);
	
	direction = point_direction(0, 0, horizontalSpeed, verticalSpeed);
	
	if (abs(hspeed) < deceleration * (maximumSpeed / maximumDefaultSpeed))
	{
		hspeed = 0;
	}
	
	if (isGrounded)
	{			
		if (instance_place(x, y + 1, o_collision) != noone)
		{
			groundImOn = instance_place(x, y + 1, o_collision);
		}
		
		if (!place_meeting(x, y + 1, o_collision))
		{
			isGrounded = false;
			
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
		if (place_meeting(x, y + 1, o_block) and isGrounded)
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
	
	if (hspeed != 0 and instance_place(x, y + 1, o_diagonal) != noone)
	{
		if (instance_place(x, y + 1, o_diagonal).image_xscale != image_xscale)
		{
			if (place_meeting(x, y + 1, o_ramp))
			{
				maximumSpeed += rampAcceleration;
			}
			
			if (place_meeting(x, y + 1, o_slope))
			{
				maximumSpeed += slopeAcceleration;
			}
		}
		else
		{
			if (place_meeting(x, y + 1, o_slope))
			{
				maximumSpeed -= slopeDeceleration;
				maximumSpeed = max(maximumSpeed, slopeMinSpeed);
			}
			
			if (place_meeting(x, y + 1, o_ramp))
			{
				maximumSpeed -= rampDeceleration;
				maximumSpeed = max(maximumSpeed, rampMinSpeed);
			}
		}
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
	if (place_meeting(x + hspeed, y, o_collision))
	{
		if (!place_meeting(x + hspeed, y - abs(hspeed) - 1, o_collision))
		{
			while (place_meeting(x + hspeed, y, o_collision))
			{
				y -= 0.5;
			}
		}
		else if (!place_meeting(x + hspeed, y + abs(hspeed) + 1, o_collision))
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
				x = (x + xx) / 2
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
	
	if (place_meeting(x + hspeed, y + vspeed, o_collision) and desiredHorizontalDirection != 0 and desiredVerticalDirection != 0)
	{
		while (!place_meeting(x + sign(hspeed), y + sign(vspeed), o_collision))
		{
			x += sign(hspeed) * 0.5;
			y += sign(vspeed) * 0.5;
		}
			
		hspeed = 0;
		vspeed = 0;
		horizontalSpeed = 0;
		verticalSpeed = 0;
		maximumSpeed = maximumDefaultSpeed;
	}
}

function scr_platformerCollision()
{	
	if (vspeed < 0)
	{
		if (place_meeting(x, y + vspeed, o_collision))
		{	
			var slopeSlide = false;
			
			if (desiredHorizontalDirection != 1 and !place_meeting(x - abs(vspeed * 2) - 1, y + vspeed, o_collision))
			{
				while (place_meeting(x, y + vspeed, o_collision))
				{
					x -= 0.5;
				}
				slopeSlide = true;
			}
			
			if (desiredHorizontalDirection != -1 and !place_meeting(x + abs(vspeed * 2) + 1, y + vspeed, o_collision))
			{
				while (place_meeting(x, y + vspeed, o_collision))
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
		if (place_meeting(x, y + vspeed, o_collision) or (vspeed == gravitation * 5 and place_meeting(x, y + vspeed * 2, o_collision)))
		{	
			while(place_free(x, y + sign(vspeed) * 0.5))
			{
				y += sign(vspeed) * 0.5;
			}
		
			if (!isGrounded)
			{
				if (place_meeting(x, y + 1, o_diagonal))
				{
					if (instance_place(x, y + 1, o_diagonal).image_xscale != sign(horizontalSpeed) and hspeed != 0 and instance_place(x, y + 1, o_diagonal).image_yscale == 1)
					{
						hspeed += vspeed * slopeSpeedTransitionFactor * image_xscale;
						if (abs(hspeed) > maximumSpeed)
						{
							maximumSpeed = abs(hspeed);
						}
					}
				}
		
				if (place_meeting(x, y + 1, o_collision))
				{
					isGrounded = true;
					canBeOnCliff = false;
					coyoteTime = maximumCoyoteTime;
				}
			}
		
			vspeed = 0;
		}
	}
	
	if (place_meeting(x + hspeed, y, o_collision))
	{
		if (!place_meeting(x + hspeed, y - abs(hspeed) - 1, o_collision))
		{
			while (place_meeting(x + hspeed, y, o_collision))
			{
				y -= 0.5;
			}
		}
		else
		{
			if (!place_meeting(x + hspeed, y + abs(hspeed) + 1, o_collision))
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
			
				if (pasive.wallRun and abs(hspeed) > acceleration)
				{
					if (abs(hspeed) > abs(vspeed))
					{
						vspeed = -min(abs(hspeed), maximumDefaultSpeed);
						platformAnimationState = changeState(true, platformAnimationState, platformWallRunState);
					}
					
					if (place_meeting(x, y + vspeed, o_collision))
					{
						vspeed = 0;
						hspeed = 0;
					}
				}
				else 
				{
					maximumSpeed = maximumDefaultSpeed;
				}
				
				hspeed = 0;
			}
		}
	}
	
	if (vspeed >= 0 and !place_meeting(x + hspeed, y + 1, o_collision) and place_meeting(x + hspeed, y + ceil(abs(hspeed)) + 1, o_collision))
	{
		while (!place_meeting(x + hspeed, y + 0.5, o_collision))
		{
			y += 0.5;
		}
	}
	
	if (place_meeting(x + hspeed, y + vspeed, o_collision) and abs(vspeed) >= 1)
	{
		var collisionObject = instance_place(x + hspeed, y + vspeed, o_collision);
		
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