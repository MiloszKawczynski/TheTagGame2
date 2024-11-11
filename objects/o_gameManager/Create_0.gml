maximumChaseTime = 1020;

chaseTime = maximumChaseTime;
changesPerChase = 4;
isGravitationOn = false;

isGameOn = false;

reset = function()
{
	chaseTime = maximumChaseTime;
	isGravitationOn = false;

	global.debugIsGravityOn = isGravitationOn;
	isGameOn = false;
	
	with(o_char)
	{
		var playerNumber = player;
		with(o_start)
		{
			if (playerNumber == image_index)
			{
				other.x = x;
				other.y = y;
			}
		}
		
		isChasing = !isChasing;
		nearestPlayer = id;
		canCaught = false;
	}
}

startStop = function()
{
	isGameOn = !isGameOn;
}

reset();

//--- Players Default Movement Rules

maximumDefaultSpeed = 6;
acceleration = 0.5;
deceleration = 0.25;
maximumSpeedDecelerationFactor = 0.25;
jumpForce = 7;
momentumJumpForce = 2;
gravitation = 0.25;
slopeAcceleration = 0.1;
slopeDeceleration = 0.1;
rampAcceleration = 0.05;
rampDeceleration = 0.05;
maximumSlopeSpeed = 3;
maximumRampSpeed = 4.5;
slopeSpeedTransitionFactor = 0.5;
maximumCoyoteTime = 10;
obstacleRange = 60;
maximumObstacleJumpForce = 10;
minimumObstacleJumpForce = 5;
maximumJumpBuffor = 10;