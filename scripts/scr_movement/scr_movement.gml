function scr_topDownMovement()
{	
	isGrounded = false;
	
	var horizontal = keyboard_check(rightKey) - keyboard_check(leftKey);
	var vertical = keyboard_check(downKey) - keyboard_check(upKey);
	
	horizontalSpeed += horizontal * acceleration;
	verticalSpeed += vertical * acceleration;
	
	if (horizontal == 0)
	{
		horizontalSpeed -= sign(horizontalSpeed) * deceleration;
	}
	
	if (vertical == 0)
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
	direction = point_direction(0, 0, horizontalSpeed, verticalSpeed) + Camera.Forward;
	
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
		log("stop");
		speed -= deceleration;
		maximumSpeed = speed;
		
		if (abs(maximumSpeed - maximumDefaultSpeed) <= deceleration)
		{
			maximumSpeed = maximumDefaultSpeed
		}
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
			var newSpeedRatio = (speed + lerp(minimumObstacleJumpForce, maximumObstacleJumpForce, 1 - (dist / obstacleRange))) / speed;
			horizontalSpeed *= newSpeedRatio;
			verticalSpeed *= newSpeedRatio;
			speed = point_distance(0, 0, horizontalSpeed, verticalSpeed);
			direction = point_direction(0, 0, horizontalSpeed, verticalSpeed) + Camera.Forward;
			if (speed > maximumSpeed)
			{
				log("boost");
				maximumSpeed = speed;
			}
		}
	}
}

function scr_platformerMovement()
{	
	if (live_call()) return live_result;
	
	horizontalSpeed = hspeed;
	verticalSpeed = vspeed;
	
	var horizontal = keyboard_check(rightKey) - keyboard_check(leftKey);
	
	horizontalSpeed += horizontal * acceleration;
		
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
	
	if (horizontal == 0)
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
		if (!place_meeting(x, y + 1, o_collision))
		{
			isGrounded = false;
		}
	}
	
	scr_platformerObstaclesInteraction(horizontal)
	
	if (sign(hspeed) != horizontal and horizontal != 0)
	{
		maximumSpeed = maximumDefaultSpeed;
		isGrounded = true;
	}
	
	if (hspeed != 0)
	{
		image_xscale = sign(hspeed);
	}
	
	if (horizontal != 0)
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
				hspeed -= slopeAcceleration * image_xscale;
				maximumSpeed = abs(hspeed);
				maximumSpeed = max(maximumSpeed, maximumSlopeSpeed);
			}
			
			if (place_meeting(x, y + 1, o_ramp))
			{
				hspeed -= rampAcceleration * image_xscale;
				maximumSpeed = abs(hspeed);
				maximumSpeed = max(maximumSpeed, maximumRampSpeed);
			}
		}
	}
}

function scr_platformerObstaclesInteraction(horizontal)
{
	var dist = distance_to_object(o_obstacle);
	if (dist < instance_nearest(x, y, o_char).obstacleRange)
	{
		if (keyboard_check_pressed(interactionKey))
		{
			vspeed -= lerp(minimumObstacleJumpForce, maximumObstacleJumpForce, 1 - (dist / obstacleRange));
			if (horizontal != sign(hspeed))
			{
				hspeed = abs(hspeed) * horizontal;
				log("EPIC TURN!", c_aqua);
			}
		}
	}
}

function scr_topDownCollision()
{	
	if (place_meeting(x + hspeed, y, o_collision))
	{	
		while(place_free(x + sign(hspeed), y))
		{
			x += sign(hspeed);
		}

		hspeed = 0;
	}
	
	if place_meeting(x, y + vspeed, o_collision)
	{	
		while(place_free(x, y + sign(vspeed)))
		{
			y += sign(vspeed);
		}
		
		vspeed = 0;
	}
	
	if place_meeting(x + hspeed, y + vspeed, o_collision)
	{
		while(place_free(x + sign(hspeed), y + sign(vspeed)))
		{
			x += sign(hspeed);
			y += sign(vspeed);
		}
		
		hspeed = 0;
		vspeed = 0;
	}
}

function scr_platformerCollision()
{	
	if (live_call()) return live_result;
	
	if (vspeed != 0 and place_meeting(x, y + vspeed, o_collision))
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
				isOnCliff = false;
				canBeOnCliff = false;
				coyoteTime = maximumCoyoteTime;
			}
		}
		
		vspeed = 0;
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
			while (!place_meeting(x + sign(hspeed), y, o_collision))
			{
				x += sign(hspeed) * 0.5;
			}
			
			hspeed = 0;
			maximumSpeed = maximumDefaultSpeed;
		}
	}
	
	if (vspeed >= 0 and !place_meeting(x + hspeed, y + 1, o_collision) and place_meeting(x + hspeed, y + abs(hspeed) + max(1, 1 * abs(hspeed) / maximumDefaultSpeed), o_collision))
	{
		while (!place_meeting(x + hspeed, y + 0.5, o_collision))
		{
			y += 0.5;
		}
	}
	
	//if (place_meeting(x + min(16, hspeed), y + min(16, vspeed), o_collision))
	//{
	//	while(place_free(x + sign(hspeed), y + sign(vspeed)))
	//	{
	//		x += sign(hspeed);
	//		y += sign(vspeed);
	//	}
		
	//	hspeed = 0;
	//	vspeed = 0;
	//	log("Colision diagonal");
	//}
}