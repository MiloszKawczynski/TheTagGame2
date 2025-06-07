function scr_setupSprites(characterReference)
{
    idleAnimation = characterReference.idleAnimation;
    
    walkAnimation = characterReference.walkAnimation;
    runAnimation = characterReference.runAnimation;
    sprintAnimation = characterReference.sprintAnimation;
    
    jumpAnimation = characterReference.jumpAnimation;
    
    fallAnimation = characterReference.fallAnimation;
    
    leapAnimation = characterReference.leapAnimation;
    
    parkourAnimation = characterReference.parkourAnimation;
    
    vaultAnimation = characterReference.vaultAnimation;
    
    tripAnimation = characterReference.tripAnimation;
    joyAnimation = characterReference.joyAnimation;
}

//--- Top Down Animation States

function scr_setupTopDownAnimationStates()
{
	topDownIdleState = function()
	{
		sprite_index = idleAnimation;
		
		topDownAnimationState = changeAnimationState(speed != 0, topDownAnimationState, topDownMoveState);
	}
	
	topDownMoveState = function()
	{
		if (speed < maximumDefaultSpeed)
		{
			sprite_index = walkAnimation;
		}
		else if (speed == maximumDefaultSpeed)
		{
			sprite_index = runAnimation;
		}
		else if (speed > maximumDefaultSpeed)
		{
			sprite_index = sprintAnimation;
		}
		
		setXScaleWithHSpeed();
		
		topDownAnimationState = changeAnimationState(speed == 0, topDownAnimationState, topDownIdleState);
	}
	
	topDownParkourState = function()
	{
		sprite_index = vaultAnimation;
		image_speed = 0.5;
		
		topDownAnimationState = changeAnimationState(playOnce(), topDownAnimationState, topDownMoveState);
	}
    
    topDownTripState = function()
	{
		sprite_index = tripAnimation;
		image_speed = 0.2;
		
        if (playOnce())
        {
            image_index = image_number - 1;
        }
	}
    
    topDownJoyState = function()
	{
		sprite_index = joyAnimation;
		image_speed = 1;
	}
	
	topDownAnimationState = topDownIdleState;
}

//--- Platform Animation States

function scr_setupPlatformAnimationStates()
{
	platformIdleState = function()
	{
		sprite_index = idleAnimation;
		setAngleDependsOnGround();
		
		platformAnimationState = changeAnimationState(hspeed != 0, platformAnimationState, platformMoveState);
		platformAnimationState = changeAnimationState(isGrounded == false, platformAnimationState, platformJumpState);
	}
	
	platformMoveState = function()
	{
		if (abs(hspeed) < maximumDefaultSpeed)
		{
			sprite_index = walkAnimation;
		}
		else if (abs(hspeed) == maximumDefaultSpeed)
		{
			sprite_index = runAnimation;
		}
		else if (abs(hspeed) > maximumDefaultSpeed)
		{
			sprite_index = sprintAnimation;
		}
		setXScaleWithHSpeed(); 
		setAngleDependsOnGround();
		
		platformAnimationState = changeAnimationState(hspeed == 0, platformAnimationState, platformIdleState);
		platformAnimationState = changeAnimationState(isGrounded == false, platformAnimationState, platformJumpState);
	}
	
	platformJumpState = function()
	{
		sprite_index = jumpAnimation;
		setXScaleWithHSpeed();
		playOnce();
		angle = lerp(angle, (abs(hspeed) / maximumDefaultSpeed) * 15, 0.1);
		stretch = clamp(1 + ((abs(vspeed) / jumpForce) * 0.3), 1, 1.3);
		squash = (1 - (stretch - 1));
		
		platformAnimationState = changeAnimationState(vspeed >= 0 , platformAnimationState, platformFallState);
		platformAnimationState = changeAnimationState(isGrounded == true, platformAnimationState, platformIdleState);
		platformAnimationState = changeAnimationState(abs(hspeed) > maximumDefaultSpeed, platformAnimationState, platformLeapState);
	}
	
	platformFallState = function()
	{
		sprite_index = fallAnimation;
		playOnce();
		setXScaleWithHSpeed();
		angle = lerp(angle, (-abs(hspeed) / maximumDefaultSpeed) * 15, 0.1);
		
		platformAnimationState = changeAnimationState(isGrounded == true, platformAnimationState, platformIdleState);
		platformAnimationState = changeAnimationState(vspeed < 0, platformAnimationState, platformJumpState);
		platformAnimationState = changeAnimationState(abs(hspeed) > maximumDefaultSpeed, platformAnimationState, platformLeapState);
	}
	
	platformLeapState = function() 
	{
		sprite_index = leapAnimation;
		image_speed = 0.225;
		angle = lerp(angle, (-abs(hspeed) / maximumDefaultSpeed) * 7, 0.1);
		setXScaleWithHSpeed();
		
		platformAnimationState = changeAnimationState(isGrounded == true, platformAnimationState, platformIdleState);
		platformAnimationState = changeAnimationState(abs(hspeed) <= maximumDefaultSpeed, platformAnimationState, platformFallState);
	}
	
	platformParkourState = function()
	{
		sprite_index = parkourAnimation;
		image_speed = 0.5;
		playOnce();
		
		platformAnimationState = changeAnimationState(vspeed >= 0, platformAnimationState, platformJumpState);
	}
	
	platformWallRunState = function()
	{
		sprite_index = sprintAnimation;
		angle = lerp(angle, -90, 0.1);
		
		platformAnimationState = changeAnimationState(place_meeting(x, y + 1, o_collision) and vspeed >= 0, platformAnimationState, platformIdleState);
		platformAnimationState = changeAnimationState(!place_meeting(x - 1, y, o_collision) and !place_meeting(x + 1, y, o_collision), platformAnimationState, platformFallState);
	}
    
    platformTripState = function()
	{
		sprite_index = tripAnimation;
		image_speed = 0.2;
		
        if (playOnce())
        {
            image_index = image_number - 1;
        }
	}
    
    platformJoyState = function()
	{
		sprite_index = joyAnimation;
		image_speed = 1;
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
				angle = lerp(angle, 45 * image_xscale * -groundImOn.image_xscale, lerpValue);
			}
			
			if (groundImOn.object_index == o_ramp)
			{
				angle = lerp(angle, 22.5 * image_xscale * -groundImOn.image_xscale, lerpValue);
			}
		}
		
		if (groundImOn.object_index == o_block)
		{
			angle = lerp(angle, 0, lerpValue);
		}
	}
}
