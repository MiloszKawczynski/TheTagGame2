event_inherited();

ui = new UI();

with(ui)
{
	mainLayer = new Layer();
	mainLayer.setGrid(10, 10, false);
	
	leftColor = new Output();
	
	with(leftColor)
	{
		var drawCircle = function()
		{
			draw_set_color(color);
			draw_circle(posX, posY, 26.5, false);
		}
		setDrawFunction(drawCircle);
		setColor(c_white);
	}
	
	rightColor = new Output();
	
	with(rightColor)
	{
		var drawCircle = function()
		{
			draw_set_color(color);
			draw_circle(posX, posY, 26.5, false);
		}
		setDrawFunction(drawCircle);
		setColor(c_white);
	}
	
	chaseBar = new Output(, -10);
	chaseBar.setSprite(s_chaseBar);
	
	roundNumber = new Text("Round 0/16", f_chaseBar);
	roundNumber.setColor(c_black);
	
	leftPortrait = new Output(15, -20);
	leftPortrait.state.setSpriteSheet(s_chaseBarPortraits, 0);
	
	leftPoints = new Text("0", f_chaseBar);
	
	rightPortrait = new Output(-15, -20);
	rightPortrait.state.setSpriteSheet(s_chaseBarPortraits, 0);
	
	rightPoints = new Text("0", f_chaseBar);
	
	chaseBarGroup = new Group();
	chaseBarGroup.setGrid(1, 1, false);
	chaseBarGroup.addComponent(-0.835, -0.19, leftColor);
	chaseBarGroup.addComponent(0.835, -0.19, rightColor);
	chaseBarGroup.addComponent(0, 0, chaseBar);
	chaseBarGroup.addComponent(-1, 0, leftPortrait);
	chaseBarGroup.addComponent(1, 0, rightPortrait);
	chaseBarGroup.addComponent(0, -0.42, roundNumber);
	chaseBarGroup.addComponent(-1.27, -0.17, leftPoints);
	chaseBarGroup.addComponent(1.27, -0.17, rightPoints);
	chaseBarGroup.setProperties(0.6, 0.6);
	
	rightPortrait.setScale(-0.6);
	
	mainLayer.addComponent(5, 1, chaseBarGroup);

	pushLayer(mainLayer);
}

maximumChaseTime = 1020;

chaseTime = maximumChaseTime;
changesPerChase = 4;
isGravitationOn = false;

isGameOn = false;

rounds = 0;

enum skillTypes
{
	sprint,
	dash,
	jumpBack
}

skill = function(_name, _usage, _replenish, _value, _rechargePercentage) constructor
{
	name = _name;
	usage = _usage;
	replenish = _replenish;
	value = _value;
	rechargePercentage = _rechargePercentage;
}

skills = [];

sprint = new skill("sprint", 0.01, 0.01, 0.33, 0);
dash = new skill("dash", 1, 0.005, 2, 1);
jumpBack = new skill("jump back", 0.33, 0.01, 2, 0.33)

array_push(skills, sprint, dash, jumpBack);

players = [];

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
		skillEnergy = 1;
		
		nearestPlayer = id;
		canCaught = false;
		
		log(string("P{0}: {1}", player + 1, other.players[player].points), color);
	}
	
	o_debugController.previousTab = -1;
	
	if (isGameOn)
	{
		wait(1.5);
	
		rounds++;
		
		if (rounds > 15)
		{
			var indexOfWinner = 0;
			for(var i = 0; i < array_length(players); i++)
			{
				if (players[i].points > players[indexOfWinner].points)
				{
					indexOfWinner = i;
				}
			}
			
			if (players[0].points == players[1].points)
			{
				log(string("Round {0}/15", rounds));
			}
			else
			{			
				log("END");
				log(string("WINNER: Player {0}", indexOfWinner), c_orange);
				
				startStop();
			}
		}
		else
		{		
			log(string("Round {0}/16", rounds));
		}
	}
}

startStop = function()
{
	isGameOn = !isGameOn;
	
	if (isGameOn)
	{
		for (var i = 0; i < array_length(players); i++)
		{
			players[i].points = 0;
		}
		
		players[0].instance.isChasing = true;
		players[1].instance.isChasing = false;
		
		rounds = 0;
		chaseTime = maximumChaseTime;
	}
}

uiUpdate = function()
{
	with(ui)
	{
		leftColor.setColor(other.players[0].instance.color);
		leftPortrait.state.setSpriteSheet(s_chaseBarPortraits, other.players[0].instance.portrait);
			
		if (array_length(other.players) == 2)
		{
			rightColor.setColor(other.players[1].instance.color);
			rightPortrait.state.setSpriteSheet(s_chaseBarPortraits, other.players[1].instance.portrait);
		}
	}
}

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

//---

x1 = 0;
x2 = 0;
y1 = 0;
y2 = 0;

alarm[0] = 3;

buffersMap = ds_map_create();