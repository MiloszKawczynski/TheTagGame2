//--- Top Down Animation States

function scr_setupTopDownAnimationStates()
{
	topDownIdleState = function()
	{
		sprite_index = s_cleaIdle;
		
		topDownAnimationState = changeState(speed != 0, topDownAnimationState, topDownWalkState);
	}
	
	topDownWalkState = function()
	{
		sprite_index = s_cleaWalk;
		setXScaleWithHSpeed();
		
		topDownAnimationState = changeState(speed > maximumDefaultSpeed, topDownAnimationState, topDownRunState);
		topDownAnimationState = changeState(speed == 0, topDownAnimationState, topDownIdleState);
	}
	
	topDownRunState = function()
	{
		sprite_index = s_cleaRun;
		setXScaleWithHSpeed();
		
		topDownAnimationState = changeState(speed <= maximumDefaultSpeed, topDownAnimationState, topDownWalkState);
	}
	
	topDownAnimationState = topDownIdleState;
}

//--- Platform Animation States

function scr_setupPlatformAnimationStates()
{
	platformIdleState = function()
	{
		sprite_index = s_cleaIdle;
		setAngleDependsOnGround();
		
		platformAnimationState = changeState(hspeed != 0, platformAnimationState, platformWalkState);
		platformAnimationState = changeState(isGrounded == false, platformAnimationState, platformJumpState);
	}
	
	platformWalkState = function()
	{
		sprite_index = s_cleaWalk;
		setXScaleWithHSpeed(); 
		setAngleDependsOnGround();
		
		platformAnimationState = changeState(hspeed > maximumDefaultSpeed, platformAnimationState, platformRunState);
		platformAnimationState = changeState(hspeed == 0, platformAnimationState, platformIdleState);
		platformAnimationState = changeState(isGrounded == false, platformAnimationState, platformJumpState);
	}
	
	platformRunState = function()
	{
		sprite_index = s_cleaRun;
		setXScaleWithHSpeed(); 
		setAngleDependsOnGround();
		
		platformAnimationState = changeState(hspeed <= maximumDefaultSpeed, platformAnimationState, platformWalkState);
		platformAnimationState = changeState(isGrounded == false, platformAnimationState, platformJumpState);
	}
	
	platformJumpState = function()
	{
		sprite_index = s_cleaJump;
		setXScaleWithHSpeed();
		playOnce();
		angle = lerp(angle, (abs(hspeed) / maximumDefaultSpeed) * 15, 0.1);
		image_yscale = min((abs(vspeed) / jumpForce) + 1, 1.75);
		
		platformAnimationState = changeState(vspeed >= 0 , platformAnimationState, platformFallState);
		platformAnimationState = changeState(isGrounded == true, platformAnimationState, platformIdleState);
	}
	
	platformFallState = function()
	{
		sprite_index = s_cleaFall;
		setXScaleWithHSpeed();
		playOnce();
		angle = lerp(angle, (-abs(hspeed) / maximumDefaultSpeed) * 15, 0.1);
		
		platformAnimationState = changeState(isGrounded == true, platformAnimationState, platformIdleState);
		platformAnimationState = changeState(vspeed < 0, platformAnimationState, platformJumpState);
	}
	
	platformAnimationState = platformIdleState;
}

function setAngleDependsOnGround(lerpValue = 0.1)
{
	if (groundImOn != noone)
	{
		if (groundImOn.image_yscale == 1)
		{
			if (groundImOn.object_index == o_slope)
			{
				//angle = 45 * image_xscale * -groundImOn.image_xscale;
				angle = lerp(angle, 45 * image_xscale * -groundImOn.image_xscale, lerpValue);
			}
			
			if (groundImOn.object_index == o_ramp)
			{
				//angle = 22.5 * image_xscale * -groundImOn.image_xscale;
				angle = lerp(angle, 22.5 * image_xscale * -groundImOn.image_xscale, lerpValue);
			}
		}
		
		if (groundImOn.object_index == o_block)
		{
			//angle = 0;
			angle = lerp(angle, 0, lerpValue);
		}
	}
}
