event_inherited();

ui = new UI();
maximumChaseTime = 1020;

chaseTime = maximumChaseTime;
changesPerChase = 4;
isGravitationOn = false;

isGameOn = false;

points = [0, 0];
rounds = 0;

enum skillTypes
{
	sprint,
	dash
}

skill = function(_name, _usage, _replenish, _value) constructor
{
	name = _name;
	usage = _usage;
	replenish = _replenish;
	value = _value;
}

sprint = new skill("sprint", 0.01, 0.01, 0.33);
dash = new skill("dash", 1, 0.005, 2);

skills = [];

array_push(skills, sprint, dash);

reset = function()
{
	with(o_debugController)
	{
		scr_clearLog();
	}
	
	chaseTime = maximumChaseTime;

	if (global.debugIsGravityOn)
	{
		global.debugIsGravityOn = !global.debugIsGravityOn;
		scr_gravitationChange();
	}
	
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
		
		speed = 0;
		hspeed = 0;
		vspeed = 0;
		desiredHorizontalDirection = 0;
		desiredVerticalDirection = 0;
		horizontalSpeed = 0;
		verticalSpeed = 0;
		
		nearestPlayer = id;
		canCaught = false;
		
		log(string("P{0}: {1}", player + 1, other.points[player]), color);
	}
	
	o_debugController.previousTab = -1;
	
	if (isGameOn)
	{
		isGameOn = false;

		wait(1.5);
	
		rounds++;
		
		if (rounds > 15)
		{
			var indexOfWinner = 0;
			for(var i = 0; i < array_length(points); i++)
			{
				if (points[i] > points[indexOfWinner])
				{
					indexOfWinner = i;
				}
			}
			
			if (points[0] == points[1])
			{
				log(string("Round {0}/15", rounds));
			
				startStop();
			}
			else
			{			
				log("END");
				log(string("WINNER: Player {0}", indexOfWinner), c_orange);
			}
		}
		else
		{		
			log(string("Round {0}/16", rounds));
			
			startStop();
		}
	}
	else
	{
		isGameOn = false;
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

//---

vignetteTime = 0;
vignettePulse = false;
pulseCounter = 0;