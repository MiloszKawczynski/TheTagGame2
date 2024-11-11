function scr_topDownMovement()
{	
	isGrounded = false;
	
	desiredHorizontalDirection = keyboard_check(rightKey) - keyboard_check(leftKey);
	desiredVerticalDirection = keyboard_check(downKey) - keyboard_check(upKey);
	
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
	if (global.debugCameraAxis and !global.debugEdit)
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
	
	if (speed > maximumDefaultSpeed)
	{
		speed -= deceleration;
		maximumSpeed = speed;
		
		if (abs(maximumSpeed - maximumDefaultSpeed) <= deceleration)
		{
			maximumSpeed = maximumDefaultSpeed
		}
	}
	
	if (speed < maximumDefaultSpeed and (desiredHorizontalDirection != 0 or desiredVerticalDirection != 0))
	{
		speed += acceleration;
		maximumSpeed = speed;
		
		if (abs(maximumSpeed - maximumDefaultSpeed) <= acceleration)
		{
			maximumSpeed = maximumDefaultSpeed
		}
	}
	
	if (speed > deceleration * 2)
	{
		lastDirection = direction;
	}
	
	scr_TopDownObstaclesInteraction();
}

function scr_TopDownObstaclesInteraction()
{
	var dist = distance_to_object(o_obstacle);
	if (dist < instance_nearest(x, y, o_char).obstacleRange)
	{
		if (keyboard_check_pressed(interactionKey))
		{
			var obstacleSpeedBoost = lerp(minimumObstacleJumpForce, maximumObstacleJumpForce, 1 - (dist / obstacleRange));
			
			if (speed != 0)
			{
				var newSpeedRatio = (speed + obstacleSpeedBoost) / speed;
				horizontalSpeed *= newSpeedRatio;
				verticalSpeed *= newSpeedRatio;
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
		}
	}
}

function scr_platformerMovement()
{	
	horizontalSpeed = hspeed;
	verticalSpeed = vspeed;
	
	desiredHorizontalDirection = keyboard_check(rightKey) - keyboard_check(leftKey);
	
	horizontalSpeed += desiredHorizontalDirection * acceleration;
		
	jumpBuffor = armez_timer(jumpBuffor, -1);
		
	if (keyboard_check_pressed(jumpKey) or jumpBuffor > 0)
	{
		if (isGrounded or coyoteTime > 0)
		{	
			jumpBuffor = 0;		
			coyoteTime = 0;
			isGrounded = false;
			verticalSpeed = -(jumpForce + momentumJumpForce * min((abs(horizontalSpeed) / maximumDefaultSpeed), 1));
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
		verticalSpeed += gravitation;
		coyoteTime = armez_timer(coyoteTime, -1);
	}
	
	if (desiredHorizontalDirection == 0)
	{
		horizontalSpeed -= sign(horizontalSpeed) * deceleration;
	}

	horizontalSpeed = clamp(horizontalSpeed, -maximumSpeed, maximumSpeed);
	
	speed = point_distance(0, 0, horizontalSpeed, verticalSpeed);
	
	direction = point_direction(0, 0, horizontalSpeed, verticalSpeed);
	
	if (abs(hspeed) < deceleration)
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
	
	if (sign(hspeed) != desiredHorizontalDirection and desiredHorizontalDirection != 0)
	{
		maximumSpeed = maximumDefaultSpeed;
	}
	
	if (hspeed != 0)
	{
		image_xscale = sign(hspeed);
	}
	
	if (desiredHorizontalDirection != 0)
	{
		if (place_meeting(x, y + 1, o_block) and isGrounded and maximumSpeed != maximumDefaultSpeed)
		{
			if (hspeed == 0)
			{
				maximumSpeed = maximumDefaultSpeed;
			}
			else
			{
				if (abs(hspeed) > maximumDefaultSpeed)
				{
					hspeed -= deceleration * maximumSpeedDecelerationFactor * image_xscale;
					maximumSpeed = abs(hspeed);
					maximumSpeed = max(maximumSpeed, maximumDefaultSpeed);
		
					if (abs(maximumSpeed - maximumDefaultSpeed) <= deceleration)
					{
						maximumSpeed = maximumDefaultSpeed
					}
				}
	
				if (abs(hspeed) < maximumDefaultSpeed)
				{
					hspeed += acceleration * image_xscale;
					maximumSpeed = abs(hspeed);
					maximumSpeed = min(maximumSpeed, maximumDefaultSpeed);
		
					if (abs(maximumSpeed - maximumDefaultSpeed) <= acceleration)
					{
						maximumSpeed = maximumDefaultSpeed
					}
				}
			}
		}
	}
	
	if (hspeed != 0 and instance_place(x, y + 1, o_diagonal) != noone)
	{
		if (instance_place(x, y + 1, o_diagonal).image_xscale != image_xscale)
		{
			if (place_meeting(x, y + 1, o_ramp))
			{
				hspeed += rampAcceleration * sign(hspeed);
				if (abs(hspeed) > maximumSpeed)
				{
					maximumSpeed = abs(hspeed);
				}
			}
			
			if (place_meeting(x, y + 1, o_slope))
			{
				hspeed += slopeAcceleration * sign(hspeed);
				if (abs(hspeed) > maximumSpeed)
				{
					maximumSpeed = abs(hspeed);
				}
			}
		}
		else
		{
			if (place_meeting(x, y + 1, o_slope))
			{
				hspeed -= slopeDeceleration * image_xscale;
				maximumSpeed = abs(hspeed);
				maximumSpeed = max(maximumSpeed, maximumSlopeSpeed);
			}
			
			if (place_meeting(x, y + 1, o_ramp))
			{
				hspeed -= rampDeceleration * image_xscale;
				maximumSpeed = abs(hspeed);
				maximumSpeed = max(maximumSpeed, maximumRampSpeed);
			}
		}
	}
}

function scr_platformerObstaclesInteraction()
{
	var dist = distance_to_object(o_obstacle);
	if (dist < instance_nearest(x, y, o_char).obstacleRange)
	{
		if (keyboard_check_pressed(interactionKey))
		{
			vspeed -= lerp(minimumObstacleJumpForce, maximumObstacleJumpForce, 1 - (dist / obstacleRange));
			if (desiredHorizontalDirection != sign(hspeed))
			{
				hspeed = abs(hspeed) * desiredHorizontalDirection;
				log("EPIC TURN!", c_aqua);
			}
		}
	}
}

function scr_topDownCollision()
{	
	if (live_call()) return live_result;
	
	if (place_meeting(x + hspeed, y, o_collision))
	{
		if (!place_meeting(x + hspeed, y - abs(hspeed) - 1, o_collision) and desiredVerticalDirection == 0)
		{
			while (place_meeting(x + hspeed, y, o_collision))
			{
				y -= 0.5;
			}
		}
		else if (!place_meeting(x + hspeed, y + abs(hspeed) + 1, o_collision) and desiredVerticalDirection == 0)
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
		if (!place_meeting(x - abs(vspeed * 2) - 1, y + vspeed, o_collision) and desiredHorizontalDirection == 0)
		{
			if (instance_place(x, y + vspeed, o_collision).object_index == o_ramp)
			{
				vspeed *= 0.5;
			}
			
			while (place_meeting(x, y + vspeed, o_collision))
			{
				x -= 0.5;
			}
		}
		else if (!place_meeting(x + abs(vspeed * 2) + 1, y + vspeed, o_collision) and desiredHorizontalDirection == 0)
		{
			if (instance_place(x, y + vspeed, o_collision).object_index == o_ramp)
			{
				vspeed *= 0.5;
			}
			
			while (place_meeting(x, y + vspeed, o_collision))
			{
				x += 0.5;
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
	
	if (place_meeting(x + hspeed, y + vspeed, o_collision))
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
	while (place_meeting(x, y, o_collision))
	{
		y -= 0.5;
	}
	
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
		if (place_meeting(x, y + vspeed, o_collision))
		{	
			while(place_free(x, y + sign(vspeed) * 0.5))
			{
				y += sign(vspeed) * 0.5;
			}
		
			if (!isGrounded)
			{
				if (place_meeting(x, y + 1, o_diagonal))
				{
					if (instance_place(x, y + 1, o_diagonal).image_xscale != sign(horizontalSpeed) and hspeed != 0)
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
			
				hspeed = 0;
				maximumSpeed = maximumDefaultSpeed;
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
		
		if (object_is_ancestor(collisionObject.object_index, o_diagonal))
		{
			hspeed = 0;
			vspeed = 0;
		}
		else
		{
			if (closerTo(0, hspeed, vspeed) == hspeed)
			{
				hspeed = 0;
			}
			else
			{
				vspeed = 0;
			}
		}
	}
}